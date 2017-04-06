package org.protobeans.monitoring.javaagent;

import org.protobeans.core.EntryPoint;
import org.protobeans.monitoring.annotation.EnableMonitoring;

@EnableMonitoring(dnsAddr = "haproxy:104.236.104.13:14567")
public class Main {
    public static void main(String[] args) {
        EntryPoint.run(Main.class);
    }
}