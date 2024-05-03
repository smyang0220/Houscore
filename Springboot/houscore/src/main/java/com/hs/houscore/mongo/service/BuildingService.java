package com.hs.houscore.mongo.service;

import com.hs.houscore.dto.RecommendAiDTO;
import com.hs.houscore.dto.RecommendDTO;
import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.repository.BuildingRepository;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.ReviewRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
        return buildingRepository.findByNewPlatPlc(address)
                .orElseThrow(() -> new IllegalArgumentException(address + " 해당 주소의 건물 정보가 존재하지 않습니다."));
    }

    public List<ReviewEntity> getBuildingReviewList(String address){
        return reviewRepository.findByAddress(address);
    }

    public List<RecommendAiDTO> getRecommendAiScoreTop5(String sigungu){
        List<BuildingEntity> buildingEntities = buildingRepository.findTop5ByNewPlatPlcContaining(sigungu);
        List<RecommendAiDTO> recommendAiDTOS = new ArrayList<>();

        for(BuildingEntity buildingEntity : buildingEntities){
            BuildingEntity.BuildingInfo buildingInfo = buildingEntity.getInformation().getBuildingInfo();
            Long reviewCnt = reviewRepository.countByAddressStartingWith(buildingEntity.getNewPlatPlc());
            recommendAiDTOS.add(RecommendAiDTO.builder()
                            .address(buildingEntity.getNewPlatPlc())
                            .aiScore(buildingEntity.getScore())
                            .pricePerRegion(setPricePerRegion(sigungu, 1000))
                            .pricePerPyeong(setPricePerPyeong(1000, buildingInfo.getArchArea()))
                            .realPrice(buildingInfo.getArchArea())
                            .reviewCnt(reviewCnt)
                    .build());
        }

        return recommendAiDTOS;
    }

    //지역대비가격 (%)
    private Double setPricePerRegion(String sigungu, Integer realPrice){
        //시군구로 같은 지역에 있는 데이터 지역 평균 가격 대비 현재 집의 백분율
        Double avgPriceByAllRegion = 3000D;
        Double pricePerRegion = (realPrice / avgPriceByAllRegion) * 100;

        return pricePerRegion;
    }
    //평당 가격
    private Double setPricePerPyeong(Integer realPrice, Double archArea){
        //1평 = 3.30579
        Double pyeongArea = archArea / 3.30579 ;
        Double pricePerPyeong = realPrice / pyeongArea;

        return pricePerPyeong;
    }

    public List<RecommendDTO> getRecommendNearby(Double lat, Double lng){
        // 가장 가까운 거주지 중 리뷰가 있는 2개의 거주지에서 가장 최근의 리뷰 하나씩 총 2개


        return null;
    }
}
