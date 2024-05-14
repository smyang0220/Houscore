package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.IndividualPubliclyAnnouncedPriceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IndividualPubliclyAnnouncedPriceRepository extends JpaRepository<IndividualPubliclyAnnouncedPriceEntity, Long>{
    List<IndividualPubliclyAnnouncedPriceEntity> findByPlatPlac(String address);
}
