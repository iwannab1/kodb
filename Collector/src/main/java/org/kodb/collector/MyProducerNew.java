package org.kodb.collector;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Date;
import java.util.Properties;
import java.util.Random;

public class MyProducerNew {
    public static void main(String[] args) {
        long events = Long.parseLong(args[0]);
        Random rnd = new Random();

        Properties props = new Properties();
        props.put("metadata.broker.list", args[1]);
        props.put("serializer.class", "kafka.serializer.StringEncoder");
        props.put("partitioner.class", "org.kodb.collector.MyPartitioner");
        props.put("request.required.acks", "1");

        KafkaProducer<String, String> producer = new KafkaProducer<String, String>(props);

        for (long nEvents = 0; nEvents < events; nEvents++) {
            long runtime = new Date().getTime();
            String ip = "192.168.2." + rnd.nextInt(255);
            String msg = runtime + ",www.example.com," + ip;
            ProducerRecord<String, String> data = new ProducerRecord<String, String>(args[0], ip, msg);
            producer.send(data);
        }
        producer.close();
    }
}