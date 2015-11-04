package org.kodb.collector.flume;

import java.nio.charset.Charset;
import java.util.Map;

import org.apache.flume.Channel;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.EventDeliveryException;
import org.apache.flume.Transaction;
import org.apache.flume.conf.Configurable;
import org.apache.flume.sink.AbstractSink;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PrintEventSink extends AbstractSink implements Configurable {

    Logger logger = LoggerFactory.getLogger(getClass());

    String dummySinkName;

    public void configure(Context context) {
        dummySinkName = context.getString("sinkName", "PrintEventSink");
    }

    @Override
    public void start() {
        logger.info("Start {} ...", dummySinkName);
    }

    @Override
    public void stop() {
        logger.info("Stop {} ...", dummySinkName);
    }

    public Status process() throws EventDeliveryException {
        Status status = null;

        Channel ch = getChannel();
        Transaction txn = ch.getTransaction();
        txn.begin();
        try {
            Event event = ch.take();
            Map<String, String> headers = event.getHeaders();
            String body = new String(event.getBody(), Charset.forName("UTF-8"));
            logger.info("{} - Take message: [headers= {}], [body= {}]", dummySinkName,  headers.toString(), body);

            txn.commit();
            status = Status.READY;
        }
        catch (Throwable t) {
            txn.rollback();
            status = Status.BACKOFF;
            if (t instanceof Error) {
                throw (Error) t;
            }
        }
        finally {
            txn.close();
        }
        return status;
    }
}