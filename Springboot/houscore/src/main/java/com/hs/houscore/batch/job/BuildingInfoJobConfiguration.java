package com.hs.houscore.batch.job;

import com.hs.houscore.batch.processor.BuildingItemProcessor;
import com.hs.houscore.batch.repository.*;
import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.repository.BuildingRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.data.RepositoryItemReader;
import org.springframework.batch.item.data.RepositoryItemWriter;
import org.springframework.batch.item.data.builder.RepositoryItemReaderBuilder;
import org.springframework.batch.item.data.builder.RepositoryItemWriterBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.domain.Sort;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;

@Configuration
@RequiredArgsConstructor
@Primary
@Slf4j
public class BuildingInfoJobConfiguration {

    private final BuildingRepository buildingRepository;
    //private final MongoTemplate mongoTemplate;

    //reader
    @Bean
    public RepositoryItemReader<BuildingEntity> buildingEntityReader() {
        log.info("배치 돌린 건물 정보 Reader");
        return new RepositoryItemReaderBuilder<BuildingEntity>()
                .repository(buildingRepository)
                .methodName("findByBatchYn")
                .arguments("n")
                .pageSize(1)
                .sorts(Collections.singletonMap("Id", Sort.Direction.ASC))
                .name("buildingEntityReader")
                .build();
    }
    //processor
    @Bean
    public BuildingItemProcessor buildingItemProcessor(MasterRegisterRepository masterRegisterRepository,
                                                       RealTransactionPriceRepository realTransactionPriceRepository,
                                                       BusRepository busRepository,
                                                       SubwayRepository subwayRepository,
                                                       HospitalRepository hospitalRepository,
                                                       LibraryRepository libraryRepository,
                                                       ParkRepository parkRepository,
                                                       SchoolRepository schoolRepository,
                                                       StoreRepository storeRepository,
                                                       SafeRankRepository safeRankRepository) {
        return new BuildingItemProcessor(masterRegisterRepository, realTransactionPriceRepository,
                busRepository, subwayRepository, hospitalRepository, libraryRepository, parkRepository,
                schoolRepository, storeRepository, safeRankRepository);
    }

    //writer
    @Bean
    public RepositoryItemWriter<BuildingEntity> buildingEntityWriter(){
        return new RepositoryItemWriterBuilder<BuildingEntity>()
                .repository(buildingRepository)
                .build();
    }
    //step
    @Bean(name = "buildingStep")
    @Transactional
    public Step buildingStep(JobRepository jobRepository, PlatformTransactionManager transactionManager,
                              RepositoryItemReader<BuildingEntity> reader, ItemProcessor<BuildingEntity, BuildingEntity> processor, RepositoryItemWriter<BuildingEntity> writer){
        log.info("빌딩 Step 시작!");
        return new StepBuilder("buildingStep", jobRepository)
                .<BuildingEntity, BuildingEntity>chunk(3, transactionManager)
                .reader(reader)
                .processor(processor)
                .writer(writer)
                .build();
    }
    //job
    @Bean
    public Job buildingJob (JobRepository jobRepository, Step buildingStep){
        log.info("빌딩 정보 입력 배치 시작!");
        return new JobBuilder("buildingJob", jobRepository)
                //.listener(listener)
                .start(buildingStep)
                .build();
    }

    @Bean
    public PlatformTransactionManager transactionManager() {
        return new JpaTransactionManager();
    }
}
