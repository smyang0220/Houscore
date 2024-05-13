package com.hs.houscore.postgre.repository;

import com.hs.houscore.postgre.entity.ReviewEntity;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<ReviewEntity, Long> {
    List<ReviewEntity> findListByAddress(@Param("address")String address);
    Page<ReviewEntity> findPageByAddress(@Param("address")String address, Pageable pageable);
    Optional<ReviewEntity> findById(Long id);
    List<ReviewEntity> findTop10ByOrderByCreatedAt();
    List<ReviewEntity> findByMemberIdOrderByCreatedAt(String memberId);
    //List<ReviewEntity> findByBuildingId(ObjectId buildingId);
    Optional<ReviewEntity> findByIdAndMemberId(Long id, String memberId);
    void deleteById(Long id);
    Long countByAddressStartingWith(String address);

}
