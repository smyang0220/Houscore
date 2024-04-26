package com.hs.houscore.mongo.repository;

import com.hs.houscore.mongo.entity.BuildingEntity;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface BuildingRepository extends MongoRepository<BuildingEntity, String> {

    Optional<BuildingEntity> findById(@Param("id")Integer Id);

    Optional<BuildingEntity> findByInformation_BuildingInfo_NewPlatPlc(@Param("newPlatPlc")String newPlatPlc);
}
