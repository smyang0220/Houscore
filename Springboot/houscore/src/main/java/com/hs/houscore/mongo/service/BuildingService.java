package com.hs.houscore.mongo.service;

import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.repository.BuildingRepository;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.ReviewRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class BuildingService {

    private final BuildingRepository buildingRepository;
    private final ReviewRepository reviewRepository;

    public List<BuildingEntity> getBuildingList(){
        return buildingRepository.findAll();
    }

    public void save(BuildingEntity buildingEntity){
        buildingRepository.save(buildingEntity);
    }

    public BuildingEntity getBuildingByAddress(String address){
        return buildingRepository.findByInformation_BuildingInfo_NewPlatPlc(address)
                .orElseThrow(() -> new IllegalArgumentException(address + " 해당 주소의 건물 정보가 존재하지 않습니다."));
    }

    public List<ReviewEntity> getBuildingReviewList(String address){
        return reviewRepository.findByAddress(address);
    }
}
