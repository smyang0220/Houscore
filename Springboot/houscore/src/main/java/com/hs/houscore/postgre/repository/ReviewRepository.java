package com.hs.houscore.postgre.repository;

import com.hs.houscore.postgre.entity.ReviewEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<ReviewEntity, Long> {
    List<ReviewEntity> findByAddress(@Param("address")String address);
    Optional<ReviewEntity> findById(Long id);
    List<ReviewEntity> findTop10ByOrderByCreatedAt();
    List<ReviewEntity> findByMemberIdOrderByCreatedAt(String memeberId);
    Optional<ReviewEntity> findByIdAndMemberId(Long id, String memberId);
    void deleteById(Long id);
}
