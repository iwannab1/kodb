package org.kodb.collector.kafka;

import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;

import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class HighLevelConsumerNew {

    private static final int NUM_THREADS = 20;

    public static void main(String[] args) throws Exception {

        final String TOPIC = args[0];

        Properties props = new Properties();
        props.put("group.id", args[1]);
        props.put("zookeeper.connect", args[2]);
        props.put("auto.commit.interval.ms", "1000");
        final KafkaConsumer<byte[], byte[]> consumer = new KafkaConsumer<byte[], byte[]>(props);
        ExecutorService executor = Executors.newFixedThreadPool(NUM_THREADS);
        executor.execute(new Runnable() {
            public void run() {
                consumer.subscribe("topic");
                Map<String, ConsumerRecords<byte[], byte[]>> records = consumer.poll(10000);
                for(String key : records.keySet()){
                    System.out.println("key : " + key);
                    ConsumerRecords<byte[], byte[]> record = records.get(key);
                    System.out.println("message : " + record.toString());
                }

            }
        });
        Thread.sleep(60000);
        consumer.close();
        executor.shutdown();
    }
}