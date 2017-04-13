package org.protobeans.monitoring.logsextractor;

import org.protobeans.core.EntryPoint;
import org.protobeans.monitoring.annotation.EnableLogsExtractor;

@EnableLogsExtractor(patterns = "s:patterns")
public class Main {
    public static void main(String[] args) {
        EntryPoint.run(Main.class);
    }
}