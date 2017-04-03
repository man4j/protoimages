package org.protobeans.monitoring.javaagent;

import org.protobeans.core.EntryPoint;
import org.protobeans.monitoring.annotation.EnableGaleraMonitoring;

@EnableGaleraMonitoring(dnsAddr = "s:MYSQL_DNS_ADDRS", rootPassword = "s:MYSQL_ROOT_PASSWORD")
public class Main {
    public static void main(String[] args) {
        EntryPoint.run(Main.class);
    }
}