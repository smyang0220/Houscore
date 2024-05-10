package com.hs.houscore.mongo.repository;

import com.hs.houscore.mongo.entity.BuildingEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.GeoNearOperation;
import org.springframework.data.mongodb.core.aggregation.TypedAggregation;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.stereotype.Repository;

import java.util.List;

@RequiredArgsConstructor
@Repository
public class BuildingRepositoryCustom  {
    private final MongoTemplate mongoTemplate;

    public List<BuildingEntity> findBuildingsWithin1Km(GeoJsonPoint center) {
        Query query = new Query();
        query.addCriteria(Criteria.where("location").nearSphere(center).maxDistance(1000));

        // 쿼리 실행
        List<BuildingEntity> buildings = mongoTemplate.find(query, BuildingEntity.class);
        return buildings;

    }
}
