package org.kodb.collector.flume;

import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.EventDrivenSource;
import org.apache.flume.channel.ChannelProcessor;
import org.apache.flume.conf.Configurable;
import org.apache.flume.event.EventBuilder;
import org.apache.flume.source.AbstractSource;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import twitter4j.*;
import twitter4j.auth.AccessToken;
import twitter4j.conf.ConfigurationBuilder;

import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;


public class TwitterSource extends AbstractSource implements EventDrivenSource, Configurable {

    private final Logger logger = LoggerFactory.getLogger(TwitterSource.class);
    private final String SEP = "\t";
    private final String CONSUMER_KEY_KEY = "consumerKey";
    private final String CONSUMER_SECRET_KEY = "consumerSecret";
    private final String ACCESS_TOKEN_KEY = "accessToken";
    private final String ACCESS_TOKEN_SECRET_KEY = "accessTokenSecret";
    private final String SEARCH_KEYWORD = "searchKeyword";

    private String consumerKey;
    private String consumerSecret;
    private String accessToken;
    private String accessTokenSecret;

    private String[] keywords;

    private final TwitterStream twitterStream = new TwitterStreamFactory(new ConfigurationBuilder()
            .setJSONStoreEnabled(true).build()).getInstance();

    public void configure(Context context) {
        consumerKey = context.getString(CONSUMER_KEY_KEY);
        consumerSecret = context.getString(CONSUMER_SECRET_KEY);
        accessToken = context.getString(ACCESS_TOKEN_KEY);
        accessTokenSecret = context.getString(ACCESS_TOKEN_SECRET_KEY);
        String searchword = context.getString(SEARCH_KEYWORD);
        keywords = searchword.trim().split(",");
    }

    public void start() {
        final ChannelProcessor channel = getChannelProcessor();
        final Map<String, String> headers = new HashMap<String, String>();
        StatusListener listener = new StatusListener() {
            public void onStatus(Status status) {
                logger.debug(status.getUser().getScreenName() + " ::: " + status.getText());
                headers.put("timestamp", String.valueOf(status.getCreatedAt().getTime()));
                headers.put("host", "local");
                String logdata = makeLogData(status);
                logger.info("LOGDATA - {} ", logdata);
                Event event = EventBuilder.withBody(logdata, Charset.forName("UTF-8"), headers);
                channel.processEvent(event);
            }

            public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
            }

            public void onScrubGeo(long userId, long upToStatusId) {
            }

            public void onException(Exception ex) {
            }

            public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
            }

            public void onStallWarning(StallWarning arg0) {
            }
        };

        logger.debug("Setting up Twitter sample stream using consumer key {} and" + " access token {}",
                consumerKey, accessToken);
        twitterStream.addListener(listener);
        twitterStream.setOAuthConsumer(consumerKey, consumerSecret);
        AccessToken token = new AccessToken(accessToken, accessTokenSecret);
        twitterStream.setOAuthAccessToken(token);

        FilterQuery query = new FilterQuery();
        query.language(new String[]{"ko", "en"});
        query.locations(new double[][]{{124.6081, 33.1061}, {130.9339, 38.6123}}).track(keywords); // South Korea
        twitterStream.filter(query);

        super.start();
    }

    @Override
    public void stop() {
        System.out.println("stop..");
        logger.debug("Shutting down Twitter sample stream...");
        twitterStream.shutdown();
        super.stop();
    }

    public String makeLogData(Status status) {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        StringBuilder builder = new StringBuilder();
        builder.append(format.format(status.getCreatedAt())).append(SEP);
        builder.append(status.getText().replaceAll("\n", " ").replaceAll(SEP, " ")).append(SEP);
        builder.append(status.getId()).append(SEP);
        builder.append(status.getUser().getScreenName()).append(SEP);
        builder.append(status.getRetweetCount());

        return builder.toString();
    }
}