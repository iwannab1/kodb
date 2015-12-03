package org.kodb.sample

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._

object First extends App{

  val conf = new SparkConf().setAppName("First")
  val sc = new SparkContext(conf)

  val readme = sc.textFile("/data/kodb/spark-1.5.2-bin-hadoop2.4/README.md")
  val lineWithSpark = readme.filter(_.contains("Spark"))
  val words = lineWithSpark.map(_.split(" ")).map(r => r(1))

  words.cache()

  val aCnt = words.filter(_.contains("a")).count()
  val bCnt = words.filter(_.contains("b")).count()

  println("lines with a : %s, lines with b : %b".format(aCnt, bCnt))

}
