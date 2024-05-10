package com.hs.houscore.mongo.repository;

import com.hs.houscore.mongo.entity.BuildingEntity;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface BuildingRepository extends MongoRepository<BuildingEntity, String> {

    Optional<BuildingEntity> findById(@Param("id")ObjectId Id);

    Optional<BuildingEntity> findByNewPlatPlcOrPlatPlc(@Param("newPlatPlc")String newPlatPlc, @Param("PlatPlc")String PlatPlc);

    List<BuildingEntity> findAllBySigungu(@Param("sigungu") String sigungu);

    //시군구에 있는 모든 지역의 실거래가 평균 조회
    Page<BuildingEntity> findByBatchYn(@Param("batchYn")String batchYn, Pageable pageable);
}
