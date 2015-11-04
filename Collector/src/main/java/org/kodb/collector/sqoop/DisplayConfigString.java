package org.kodb.collector.sqoop;


import org.apache.sqoop.client.SqoopClient;
import org.apache.sqoop.model.MConfig;
import org.apache.sqoop.model.MInput;

import java.util.List;
import java.util.ResourceBundle;

public class DisplayConfigString {

    private static void describe(List<MConfig> configs, ResourceBundle resource) {
        for (MConfig config : configs) {
            System.out.println(resource.getString(config.getLabelKey())+":");
            List<MInput<?>> inputs = config.getInputs();
            for (MInput input : inputs) {
                System.out.println(resource.getString(input.getLabelKey()) + " : " + input.getValue());
            }
            System.out.println();
        }
    }

    public static void main(String[] args){
        SqoopClient client = new SqoopClient(args[0]);
        long connectorId = Long.valueOf(args[1]);
        describe(client.getConnector(connectorId).getLinkConfig().getConfigs(), client.getConnectorConfigBundle(connectorId));
        describe(client.getConnector(connectorId).getFromConfig().getConfigs(), client.getConnectorConfigBundle(connectorId));
        describe(client.getConnector(connectorId).getToConfig().getConfigs(), client.getConnectorConfigBundle(connectorId));

    }
}
