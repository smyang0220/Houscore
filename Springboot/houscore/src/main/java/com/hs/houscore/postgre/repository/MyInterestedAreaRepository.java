package com.hs.houscore.postgre.repository;

import com.hs.houscore.postgre.entity.MyInterestedAreaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MyInterestedAreaRepository extends JpaRepository<MyInterestedAreaEntity, Long> {
    List<MyInterestedAreaEntity> findByMemberId(String id);
    Optional<MyInterestedAreaEntity> findByMemberIdAndAreaId(String memberId, Long areaId);
}
