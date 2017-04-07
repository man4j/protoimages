package org.protobeans.monitoring.javaagent;

import org.protobeans.core.EntryPoint;
import org.protobeans.monitoring.annotation.EnableDockerMonitoring;
import org.protobeans.monitoring.annotation.EnableServiceMonitoring;

@EnableServiceMonitoring(dnsAddr = "s:DNS_ADDRS")
@EnableDockerMonitoring
public class Main {
    public static void main(String[] args) {
        EntryPoint.run(Main.class);
    }
}