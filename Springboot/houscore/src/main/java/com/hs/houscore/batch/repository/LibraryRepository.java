package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.LibraryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LibraryRepository extends JpaRepository<LibraryEntity, Long> {
    @Query(value = "SELECT b.*, " +
            "ST_Distance(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography), " +
            "CAST(ST_SetSRID(ST_Point(b.latitude, b.longitude), 4326) AS geography)) AS distance " +
            "FROM library b " +
            "WHERE ST_DWithin(CAST(ST_SetSRID(ST_Point(:latitude, :longitude), 4326) AS geography), " +
            "CAST(ST_SetSRID(ST_Point(b.latitude, b.longitude), 4326) AS geography), :distance) " +
            "ORDER BY distance asc",
            nativeQuery = true)
    List<Object[]> findLibraryByDistance(
            @Param("latitude") Double userLatitude,
            @Param("longitude") Double userLongitude,
            @Param("distance") Integer distance);
}
