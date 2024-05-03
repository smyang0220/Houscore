package com.hs.houscore.batch.repository;

import com.hs.houscore.batch.entity.MasterRegisterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MasterRegisterRepository extends JpaRepository<MasterRegisterEntity,Long> {
    Optional<MasterRegisterEntity> findById(Long id);
    Optional<MasterRegisterEntity> findByNewPlatPlcOrPlatPlc(String newPlatPlc, String oldPlatPlc);
}
