package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.SchoolEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SchoolRepository extends JpaRepository<SchoolEntity, Long> {
    @Query(value = "SELECT b.*, " +
            "ST_Distance(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography), " +
            "CAST(ST_SetSRID(ST_Point(b.latitude, b.longitude), 4326) AS geography)) AS distance " +
            "FROM School b " +
            "WHERE ST_DWithin(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography), " +
            "CAST(ST_SetSRID(ST_Point(b.latitude, b.longitude), 4326) AS geography), :distance) ",
            nativeQuery = true)
    List<Object[]> findSchoolByDistance(
            @Param("latitude") Double userLatitude,
            @Param("longitude") Double userLongitude,
            @Param("distance") Integer distance);
}
