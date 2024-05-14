package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.BusEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BusRepository extends JpaRepository<BusEntity, Long> {
    @Query(value = "SELECT b.*, " +
            "ST_Distance(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography), " +
            "CAST(ST_SetSRID(ST_Point(b.latitude, b.longitude), 4326) AS geography)) AS distance " +
            "FROM bus b " +
            "WHERE ST_DWithin(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography), " +
            "CAST(ST_SetSRID(ST_Point(b.latitude, b.longitude), 4326) AS geography), :distance) " +
            "AND b.id IN (" +
            "SELECT MIN(b2.id) FROM bus b2 WHERE b2.bus_stop_name = b.bus_stop_name GROUP BY b2.bus_stop_name)" +
            "ORDER BY distance asc",
            nativeQuery = true)
    List<Object[]> findBusByDistance(
            @Param("latitude") Double userLatitude,
            @Param("longitude") Double userLongitude,
            @Param("distance") Integer distance);
}
