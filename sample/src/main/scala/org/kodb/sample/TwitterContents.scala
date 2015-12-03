package org.kodb.sample

import org.apache.spark.SparkConf
import org.apache.spark.streaming.twitter._
import org.apache.spark.streaming.{Seconds, StreamingContext}

object TwitterContents {
  def main(args: Array[String]) {
    val Array(consumerKey, consumerSecret, accessToken, accessTokenSecret) = args.take(4)
    val filters = args.takeRight(args.length - 4)

    System.setProperty("twitter4j.oauth.consumerKey", consumerKey)
    System.setProperty("twitter4j.oauth.consumerSecret", consumerSecret)
    System.setProperty("twitter4j.oauth.accessToken", accessToken)
    System.setProperty("twitter4j.oauth.accessTokenSecret", accessTokenSecret)

    val sparkConf = new SparkConf().setAppName("TwitterContents")
    val ssc = new StreamingContext(sparkConf, Seconds(5))
    val stream = TwitterUtils.createStream(ssc, None, filters)

    //     val fields: Seq[(Status => Any, String, String)] = Seq(
    //       (s => s.getId, "id", "BIGINT"),
    //       (s => s.getInReplyToStatusId, "reply_status_id", "BIGINT"),
    //       (s => s.getInReplyToUserId, "reply_user_id", "BIGINT"),
    //       (s => s.getRetweetCount, "retweet_count", "INT"),
    //       (s => s.getText, "text", "STRING"),
    //       (s => Option(s.getGeoLocation).map(_.getLatitude()).getOrElse(""), "latitude", "FLOAT"),
    //       (s => Option(s.getGeoLocation).map(_.getLongitude()).getOrElse(""), "longitude", "FLOAT")
    //     )

    stream.foreachRDD(rdd => {
      rdd.foreach(status => {
        println("ID : %s".format(status.getId))
        println("status id : %s".format(status.getInReplyToStatusId))
        println("user id : %s".format(status.getInReplyToUserId))
        println("retweetcnt : %s".format(status.getRetweetCount))
        println("text : %s".format(status.getText))
      })
    })
    ssc.start()
    ssc.awaitTermination()
  }
}
