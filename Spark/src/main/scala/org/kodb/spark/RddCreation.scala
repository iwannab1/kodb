package org.kodb.spark

import org.apache.hadoop.io.{IntWritable, Text}
import org.apache.hadoop.mapred.SequenceFileOutputFormat
import org.apache.spark.{SparkContext, SparkConf}

object RddCreation extends App{
  val conf = new SparkConf().setAppName("RddCreation").setMaster("local[*]")
  val sc = new SparkContext(conf)
  // wholetextfile
  val wholefile = sc.wholeTextFiles("/spark")
  val filelist = wholefile.collect

  for (list <- filelist) {
    System.out.println("key : " + list._1)
    System.out.println("key : " + list._2)
  }
  //SequenceFile
  val input = Array(("a", 1), ("a", 2), ("b", 3))
  val rdd = sc.parallelize(input)
  rdd.saveAsTextFile("/tmp/sequence.txt")
  rdd.saveAsHadoopFile("/tmp/sequenceHadoop.txt", classOf[Text], classOf[IntWritable], classOf[SequenceFileOutputFormat[_, _]])

}
