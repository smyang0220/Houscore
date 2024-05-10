package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.SafeRankEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SafeRankRepository extends JpaRepository<SafeRankEntity, Long> {
    SafeRankEntity findByAreaContaining (String area);
}
