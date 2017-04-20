package org.protobeans.monitoring.logsextractor;

import org.protobeans.core.EntryPoint;
import org.protobeans.monitoring.annotation.EnableLogsExtractor;
import org.protobeans.monitoring.service.logsextractor.FillMetadataProcessingStage;
import org.protobeans.monitoring.service.logsextractor.JsonLineProcessingStage;
import org.protobeans.monitoring.service.logsextractor.LogOutputProcessingStage;
import org.protobeans.monitoring.service.logsextractor.LogProcessingChain;
import org.protobeans.monitoring.service.logsextractor.MultilineProcessingStage;
import org.springframework.context.annotation.Bean;

@EnableLogsExtractor(patterns = "s:patterns")
public class Main {
    @Bean
    public LogProcessingChain logProcessingChain() {
        return new LogProcessingChain().add(new MultilineProcessingStage(new String[] {" ", "\t", "\r", "\n", "}"}, new String[] {":", "{"}))
                                       .add(new FillMetadataProcessingStage())
                                       .add(new JsonLineProcessingStage())
                                       .add(new LogOutputProcessingStage());
    }
    
    public static void main(String[] args) {
        EntryPoint.run(Main.class);
    }
}