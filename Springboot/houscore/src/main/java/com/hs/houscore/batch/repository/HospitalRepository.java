package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.HospitalEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HospitalRepository extends JpaRepository<HospitalEntity, Long> {
    @Query(value = """
            SELECT b.*,
            ST_Distance(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography),
            CAST(ST_SetSRID(ST_Point(b.latitude, b.longitude), 4326) AS geography)) AS distance
            FROM (
            SELECT *
            FROM hospital
            WHERE ST_DWithin(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography),
            CAST(ST_SetSRID(ST_Point(hospital.latitude, hospital.longitude), 4326) AS geography), :distance)
            ) AS b
            WHERE (b.hospital_name, b.id) IN (
            SELECT hospital_name, MIN(id)
            FROM hospital
            GROUP BY hospital_name
            )
            ORDER BY distance asc
            """,
            nativeQuery = true)
    List<Object[]> findHospitalByDistance(
            @Param("latitude") Double userLatitude,
            @Param("longitude") Double userLongitude,
            @Param("distance") Integer distance);
}
