package org.protobeans.monitoring.javaagent;

import org.protobeans.core.EntryPoint;
import org.protobeans.monitoring.annotation.EnableMonitoring;

@EnableMonitoring(dnsAddr = "s:DNS_ADDRS")
public class Main {
    public static void main(String[] args) {
        EntryPoint.run(Main.class);
    }
}