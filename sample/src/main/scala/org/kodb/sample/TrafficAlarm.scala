package org.kodb.sample

import java.io.{InputStreamReader, BufferedReader}
import java.util
import java.util.Date

import akka.actor.ActorSystem
import org.apache.http.client.methods.{HttpPost, HttpGet}
import org.apache.http.impl.client.HttpClients
import org.apache.http.util.EntityUtils
import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkConf
import org.apache.spark.storage.StorageLevel
import org.apache.spark.streaming.receiver.Receiver
import org.codehaus.jettison.json.{JSONObject, JSONArray}

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.collection.JavaConversions._

/**
  * Created by root on 15. 11. 10.
  */
object TrafficAlram extends Serializable {
  val defaultParam = Map(
    ("MinX" -> "126.22681"),
    ("MaxX" -> "129.35792"),
    ("MinY" -> "35.03472"),
    ("MaxY" -> "37.88807")
  )
  val defaultSql = "select type, coordx, coordy, time, msg, direction from traffic"

  def main(args: Array[String]): Unit = {
    val sql = defaultSql
    val params = defaultParam

    start(sql = sql, params = params)
  }

  def start(sql: String = defaultSql, params: Map[String, String] = defaultParam) {
    val conf = new SparkConf().setAppName("Traffic Streaming").setMaster("local[*]")

    val ssc = new StreamingContext(conf, Seconds(20))
    val trafficEventDS2 = ssc.receiverStream(new TrafficEventReceiver(params + ("type" -> "its"), 20)) // 일반국도 공사 정보
    val trafficIncidentDS2 = ssc.receiverStream(new TrafficIncidentReceiver(params + ("type" -> "its"), 20)) // 일반국도 사고 정보

    val lines = trafficIncidentDS2.union(trafficEventDS2)

    lines.foreachRDD(rdd => {
      if(rdd.count() > 0) {
        val sqlContext = new org.apache.spark.sql.SQLContext(rdd.sparkContext)
        val traffic = sqlContext.read.json(rdd)
        traffic.registerTempTable("traffic")
        //traffic.printSchema()
        val result = sqlContext.sql(sql).distinct()
        //result.show()
        result.foreach(row => {
          val jsonData = s"""{"type":"${row.get(0).toString}","coordx":${row.get(1).toString.toDouble},"coordy":${row.get(2).toString.toDouble},"time":"${row.get(3).toString}","msg":"${row.get(4).toString}","direction":"${row.get(5).toString}"}"""
          println(jsonData)
        })
      }
    })
    println("======= start =========")
    ssc.start()
    ssc.awaitTermination()
  }
}

// 교통사고정보
class TrafficIncidentReceiver(paramMap:Map[String, String], interval: Long) extends Receiver[String](StorageLevel.MEMORY_AND_DISK) {
  override def onStart(): Unit = {
    println("Start TrafficIncidentReceiver..")
    new Thread("TrafficIncidentReceiver") {
      override def run() { receive() }
    }.start()
  }
  override def onStop(): Unit = {
    println("Stop TrafficIncidentReceiver..")
  }

  def receive(): Unit = {
    val system = ActorSystem("MySystem")
    system.scheduler.schedule(0 seconds, interval seconds) {
      try {
        val jsonStr = getTrafficData()
        val list = parseJson(jsonStr)
        println("TrafficIncidentReceiver size:"+list.length)
        list.foreach { s =>
          if(!isStopped) {
            store(s)
          }
        }
      } catch {
        case e: Exception => e.printStackTrace()
      }
    }
  }

  def parseJson(jsonString: String) = {
    val list = new util.ArrayList[String]()
    val jsonArray = new JSONArray(jsonString)
    for(index <- 0 to jsonArray.length() - 1) {
      val json = jsonArray.getJSONObject(index)
      val newJson = new JSONObject()
      newJson.put("type","incident")
      newJson.put("coordx",json.getDouble("coordx"))
      newJson.put("coordy",json.getDouble("coordy"))
      newJson.put("time", new Date().toString)
      newJson.put("msg", json.getString("incidentmsg"))
      newJson.put("direction", json.getString("eventdirection"))

      list.add(newJson.toString)
    }
    list
  }

  def getTrafficData(): String = {
    val baseUrl = "http://openapi.its.go.kr/api/NIncidentIdentity?key=1447062467480&ReqType=2&getType=json"

    val httpclient = HttpClients.createDefault()
    val urlString = baseUrl + "&" + mapToReqString(paramMap)
    val httpGet = new HttpGet(urlString)
    val response = httpclient.execute(httpGet)

    try {
      val entity = response.getEntity()
      new String(EntityUtils.toByteArray(entity))
    } finally {
      response.close()
      httpclient.close()
    }
  }
  def mapToReqString(paramMap: Map[String, String]): String = {
    paramMap.map(p => p._1 + "=" + p._2).mkString("&")
  }
}


// 도로공사정보
class TrafficEventReceiver(paramMap:Map[String, String], interval: Long) extends Receiver[String](StorageLevel.MEMORY_AND_DISK){
  override def onStart(): Unit = {
    println("Start TrafficEventReceiver..")
    new Thread("TrafficEventReceiver") {
      override def run() { receive() }
    }.start()
  }
  override def onStop(): Unit = {
    println("Stop TrafficEventReceiver..")
  }

  def receive(): Unit = {
    val system = ActorSystem("MySystem")
    system.scheduler.schedule(0 seconds, interval seconds) {
      try {
        val jsonStr = getTrafficData()
        val list = parseJson(jsonStr)
        println("TrafficEventReceiver size:"+list.length)
        list.foreach { s =>
          if (!isStopped) {
            store(s)
          }
        }
      } catch {
        case e: Exception => e.printStackTrace()
      }
    }
  }

  def parseJson(jsonString: String) = {
    val list = new util.ArrayList[String]()
    val jsonArray = new JSONArray(jsonString)
    for(index <- 0 to jsonArray.length() - 1) {
      val json = jsonArray.getJSONObject(index)
      val newJson = new JSONObject()
      newJson.put("type","event")
      newJson.put("coordx",json.getDouble("coordx"))
      newJson.put("coordy",json.getDouble("coordy"))
      newJson.put("time", json.getString("eventstartday"))
      newJson.put("msg", json.getString("eventstatusmsg"))
      newJson.put("direction", json.optString("eventdirection", ""))

      list.add(newJson.toString)
    }
    list
  }

  def getTrafficData(): String = {
    val baseUrl = "http://openapi.its.go.kr/api/NEventIdentity?key=1447062467480&ReqType=2&getType=json"

    val httpclient = HttpClients.createDefault()
    val urlString = baseUrl + "&" + mapToReqString(paramMap)
    val httpGet = new HttpGet(urlString)
    val response = httpclient.execute(httpGet)

    try {
      val entity = response.getEntity()
      new String(EntityUtils.toByteArray(entity))
    } finally {
      response.close()
      httpclient.close()
    }
  }
  def mapToReqString(paramMap: Map[String, String]): String = {
    paramMap.map(p => p._1 + "=" + p._2).mkString("&")
  }
}
