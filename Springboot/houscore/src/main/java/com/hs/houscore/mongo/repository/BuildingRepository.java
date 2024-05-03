package com.hs.houscore.mongo.repository;

import com.hs.houscore.mongo.entity.BuildingEntity;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface BuildingRepository extends MongoRepository<BuildingEntity, String> {

    Optional<BuildingEntity> findById(@Param("id")Integer Id);

    Optional<BuildingEntity> findByInformation_BuildingInfo_NewPlatPlc(@Param("newPlatPlc")String newPlatPlc);

    List<BuildingEntity> findTop5ByInformation_BuildingInfo_NewPlatPlcContaining(@Param("newPlatPlc") String sigungu);

    //시군구에 있는 모든 지역의 실거래가 평균 조회

}
