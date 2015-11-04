package org.kodb.collector.sqoop;

import org.apache.sqoop.client.SqoopClient;
import org.apache.sqoop.model.*;
import org.apache.sqoop.submission.counter.Counter;
import org.apache.sqoop.submission.counter.CounterGroup;
import org.apache.sqoop.submission.counter.Counters;
import org.apache.sqoop.validation.Status;

public class DBtoHDFSClient {

    private SqoopClient sqoopclient;
    private long RDBS_LINK = 1;
    private long HDFS_LINK = 3;

    public DBtoHDFSClient(String url){
        sqoopclient = new SqoopClient(url);
    }

    public MLink createFromLink() throws Exception{
        MLink fromLink = sqoopclient.createLink(RDBS_LINK);
        fromLink.setName("RDBMSLink");
        fromLink.setCreationUser("KODB");
        MLinkConfig FromLinkConfig = fromLink.getConnectorLinkConfig();

        // config string 이름은 show connector --all 로 확인 가능
        FromLinkConfig.getStringInput("linkConfig.connectionString").setValue("jdbc:mysql://master.raonserver.com/employees");
        FromLinkConfig.getStringInput("linkConfig.jdbcDriver").setValue("com.mysql.jdbc.Driver");
        FromLinkConfig.getStringInput("linkConfig.username").setValue("raon");
        FromLinkConfig.getStringInput("linkConfig.password").setValue("raonpass");
        FromLinkConfig.getStringInput("linkConfig.password").setValue("raonpass");
        Status status = sqoopclient.saveLink(fromLink);
        if(status.canProceed()) {
            System.out.println("Success : " + fromLink.getPersistenceId());
        } else {
            throw new Exception("Fail to create Link");
        }

        return fromLink;
    }

    public MLink createToLink() throws Exception{
        MLink toLink = sqoopclient.createLink(HDFS_LINK);
        toLink.setName("HDFSLink");
        toLink.setCreationUser("KODB");
        MLinkConfig ToLinkConfig = toLink.getConnectorLinkConfig();

        // config string 이름은 show connector --all 로 확인 가능
        ToLinkConfig.getStringInput("linkConfig.uri").setValue("hdfs://master.raonserver.com:8020/");
        ToLinkConfig.getStringInput("linkConfig.confDir").setValue("/etc/hadoop/conf");
        Status status = sqoopclient.saveLink(toLink);
        if(status.canProceed()) {
            System.out.println("Success : " + toLink.getPersistenceId());
        } else {
            throw new Exception("Fail to create Link");
        }

        return toLink;
    }

    public MJob createJob(long fromId, long toId) throws Exception{
        MJob job = sqoopclient.createJob(fromId, toId);
        job.setName("JavaClientJob");
        job.setCreationUser("KODB");
        MFromConfig fromJobConfig = job.getFromJobConfig();
        fromJobConfig.getStringInput("fromJobConfig.schemaName").setValue("employees");
        fromJobConfig.getStringInput("fromJobConfig.tableName").setValue("employees");
        MToConfig toJobConfig = job.getToJobConfig();
        toJobConfig.getStringInput("toJobConfig.outputDirectory").setValue("/sqoop");
        MDriverConfig driverConfig = job.getDriverConfig();
        driverConfig.getStringInput("throttlingConfig.numExtractors").setValue("3");

        Status status = sqoopclient.saveJob(job);
        if(status.canProceed()) {
            System.out.println("Success : " + job.getPersistenceId());
        } else {
            throw new Exception("Fail to create job");
        }

        return job;
    }

    public void startJob(long jobId) throws Exception{
        MSubmission submission = sqoopclient.startJob(jobId);

        if(submission.getStatus().isRunning() && submission.getProgress() != -1) {
            System.out.println("Progress : " + String.format("%.2f %%", submission.getProgress() * 100));
        }

        Counters counters = submission.getCounters();
        if(counters != null) {
            System.out.println("Counters:");
            for(CounterGroup group : counters) {
                System.out.print("\t");
                System.out.println(group.getName());
                for(Counter counter : group) {
                    System.out.print("\t\t");
                    System.out.print(counter.getName());
                    System.out.print(": ");
                    System.out.println(counter.getValue());
                }
            }
        }
        if(submission.getError() != null) {
            throw new Exception(submission.getError().getErrorDetails());
        }
    }

    public static void main(String[] args){

        DBtoHDFSClient client = new DBtoHDFSClient(args[0]);

        try {
            MLink fromLink = client.createFromLink();
            MLink toLink = client.createToLink();
            MJob job = client.createJob(fromLink.getPersistenceId(), toLink.getPersistenceId());
            client.startJob(job.getPersistenceId());

        }catch(Exception e){
            e.printStackTrace();
        }

    }
}
