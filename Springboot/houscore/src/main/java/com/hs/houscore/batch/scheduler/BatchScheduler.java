package com.hs.houscore.batch.scheduler;

import com.hs.houscore.batch.job.BuildingInfoJobConfiguration;
import com.hs.houscore.mongo.entity.BuildingEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.JobParametersInvalidException;
import org.springframework.batch.core.configuration.JobRegistry;
import org.springframework.batch.core.configuration.support.JobRegistryBeanPostProcessor;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.repository.JobExecutionAlreadyRunningException;
import org.springframework.batch.core.repository.JobInstanceAlreadyCompleteException;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.repository.JobRestartException;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.data.RepositoryItemReader;
import org.springframework.batch.item.data.RepositoryItemWriter;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;

import java.util.Date;

@RequiredArgsConstructor
@Component
@Slf4j
public class BatchScheduler {

    private final JobLauncher jobLauncher;
    private final JobRepository jobRepository;
    private final JobRegistry jobRegistry;
    private final BuildingInfoJobConfiguration buildingInfoJobConfiguration;
    private final RepositoryItemReader<BuildingEntity> reader;
    private final ItemProcessor<BuildingEntity, BuildingEntity> processor;
    private final RepositoryItemWriter<BuildingEntity> writer;
    private final PlatformTransactionManager transactionManager;

//    @Bean
//    public JobRegistryBeanPostProcessor jobRegistryBeanPostProcessor(){
//        //배치 처리 상태를 데이터 저장소에 보관
//        JobRegistryBeanPostProcessor jobProcessor = new JobRegistryBeanPostProcessor();
//        jobProcessor.setJobRegistry(jobRegistry);
//        return jobProcessor;
//    }

    @Scheduled(fixedRate = 1800000)  //600000 = 10분
    public void runJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters jobParameters = new JobParameters();
        log.info("10분 스캐줄러 작동중");
        jobLauncher.run(buildingInfoJobConfiguration
                        .buildingJob(jobRepository, buildingInfoJobConfiguration.buildingStep(jobRepository,transactionManager, reader, processor, writer)),
                new JobParametersBuilder().addDate("date", new Date()).toJobParameters());
    }
}
