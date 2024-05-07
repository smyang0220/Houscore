package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.RealTransactionPriceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RealTransactionPriceRepository extends JpaRepository<RealTransactionPriceEntity, Long> {
    List<RealTransactionPriceEntity> findByPlatPlcAndTradeType(@Param("platPlc")String platPlc, @Param("tradeType")String tradeType);
}
