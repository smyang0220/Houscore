package com.hs.houscore.mongo.service;

import com.hs.houscore.dto.BuildingDetailDTO;
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

    public BuildingDetailDTO getBuildingByAddress(String address, Double lat, Double lng){
        BuildingEntity buildingEntity = buildingRepository.findByNewPlatPlcOrPlatPlc(address, address)
                .orElse(null);
        if(buildingEntity != null){
            return buildingDetailDTOMapper(buildingEntity);
        }
        return setBuildingInfo(address, lat, lng);
    }

    @Transactional
    public BuildingDetailDTO setBuildingInfo(String address, Double lat, Double lng) {
        BuildingEntity buildingEntity = BuildingEntity.builder()
                .platPlc(address)
                .newPlatPlc("")
                .batchYn("n")
                .lat(lat)
                .lng(lng)
                .information(null)
                .build();

        save(buildingEntity);
        buildingEntity = buildingRepository.findByNewPlatPlcOrPlatPlc(address, address)
                .orElseThrow(() -> new IllegalArgumentException("건물 정보가 존재하지 않습니다."));
        return BuildingDetailDTO.builder()
                .id(buildingEntity.getId())
                .score(buildingEntity.getScore())
                .lat(buildingEntity.getLat())
                .lng(buildingEntity.getLng())
                .platPlc(buildingEntity.getPlatPlc())
                .newPlatPlc(buildingEntity.getNewPlatPlc())
                .buildingInfo(null)
                .build();
    }

    private BuildingDetailDTO buildingDetailDTOMapper(BuildingEntity buildingEntity) {
        BuildingEntity.BuildingInfo buildingInfo = buildingEntity.getInformation().getBuildingInfo();
        return BuildingDetailDTO.builder()
                .id(buildingEntity.getId())
                .score(buildingEntity.getScore())
                .lat(buildingEntity.getLat())
                .lng(buildingEntity.getLng())
                .platPlc(buildingEntity.getPlatPlc())
                .newPlatPlc(buildingEntity.getNewPlatPlc())
                .buildingInfo(BuildingDetailDTO.BuildingInfo.builder()
                        .platArea(buildingInfo.getPlatArea())
                        .archArea(buildingInfo.getArchArea())
                        .totArea(buildingInfo.getTotArea())
                        .bcRat(buildingInfo.getBcRat())
                        .vlRat(buildingInfo.getVlRat())
                        .mainPurpsCdNm(buildingInfo.getMainPurpsCdNm())
                        .regstrKindCd(buildingInfo.getRegstrKindCd())
                        .regstrKindCdNm(buildingInfo.getRegstrKindCdNm())
                        .hhldCnt(buildingInfo.getHhldCnt())
                        .mainBldCnt(buildingInfo.getMainBldCnt())
                        .totPkngCnt(buildingInfo.getTotPkngCnt())
                        .build())
                .build();
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
