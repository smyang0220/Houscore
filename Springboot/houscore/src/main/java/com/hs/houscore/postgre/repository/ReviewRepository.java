package com.hs.houscore.postgre.repository;

import com.hs.houscore.postgre.entity.ReviewEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReviewRepository extends JpaRepository<ReviewEntity, Long> {
    List<ReviewEntity> findByAddress(@Param("address")String address);
}
