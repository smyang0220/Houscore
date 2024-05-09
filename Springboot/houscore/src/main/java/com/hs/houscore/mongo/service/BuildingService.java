package com.hs.houscore.mongo.service;

import com.hs.houscore.batch.entity.BusEntity;
import com.hs.houscore.batch.repository.BusRepository;
import com.hs.houscore.dto.BuildingDetailDTO;
import com.hs.houscore.dto.BuildingInfraDTO;
import com.hs.houscore.dto.RecommendAiDTO;
import com.hs.houscore.dto.RecommendDTO;
import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.repository.BuildingRepository;
import com.hs.houscore.mongo.repository.BuildingRepositoryCustom;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.ReviewRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class BuildingService {

    private final BuildingRepository buildingRepository;
    private final ReviewRepository reviewRepository;
    private final BusRepository busRepository;
    private final BuildingRepositoryCustom buildingRepositoryCustom;
    private final int PAGE_SIZE = 5;

    public List<BuildingEntity> getBuildingList(){
        return buildingRepository.findAll();
    }

    public void save(BuildingEntity buildingEntity){
        buildingRepository.save(buildingEntity);
    }

    public BuildingDetailDTO getBuildingByAddress(String address, Double lat, Double lng){
        List<BusEntity> bus = busRepository.findBusByDistance(lat,lng,500);
        for(BusEntity busEntity : bus){
            System.out.println(busEntity.toString());
        }
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
                .score(0.0)
                .platPlc(address)
                .newPlatPlc("")
                .batchYn("n")
                .location(new GeoJsonPoint(lng, lat))
                .information(BuildingEntity.Information.builder()
                        .buildingInfo(new BuildingEntity.BuildingInfo())
                        .priceInfo(new BuildingEntity.PriceInfo())
                        .infraInfo(new BuildingEntity.InfraInfo())
                        .securityInfo(new BuildingEntity.SecurityInfo())
                        .trafficInfo(new BuildingEntity.TrafficInfo())
                        .build())
                .build();

        save(buildingEntity);
        buildingEntity = buildingRepository.findByNewPlatPlcOrPlatPlc(address, address)
                .orElseThrow(() -> new IllegalArgumentException("건물 정보가 존재하지 않습니다."));
        return BuildingDetailDTO.builder()
                .id(buildingEntity.getId())
                .score(buildingEntity.getScore())
                .lat(buildingEntity.getLocation().getY())
                .lng(buildingEntity.getLocation().getX())
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
                .lat(buildingEntity.getLocation().getY())
                .lng(buildingEntity.getLocation().getX())
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
                        .sigunguCd(buildingInfo.getSigunguCd())
                        .bjdongCd(buildingInfo.getBjdongCd())
                        .bldNm(buildingInfo.getBldNm())
                        .pnuCode(buildingInfo.getPnuCode())
                        .build())
                .build();
    }

    public BuildingInfraDTO getBuildingInfra(String address){
        BuildingEntity buildingEntity = buildingRepository.findByNewPlatPlcOrPlatPlc(address, address)
                .orElse(null);
        if(buildingEntity != null){
            return setBuildingInfra(buildingEntity);
        }

        return null;
    }

    private BuildingInfraDTO setBuildingInfra(BuildingEntity building) {
        if(building.getInformation() == null) return BuildingInfraDTO.builder().build();
        BuildingInfraDTO.Infras infra = new BuildingInfraDTO.Infras();
        if(building.getInformation().getBuildingInfo() != null) {
            infra = BuildingInfraDTO.Infras.builder()
                    .medicalFacilities(building.getInformation().getInfraInfo().getMedicalFacilities())
                    .parks(building.getInformation().getInfraInfo().getParks())
                    .schools(building.getInformation().getInfraInfo().getSchools())
                    .libraries(building.getInformation().getInfraInfo().getLibraries())
                    .supermarkets(building.getInformation().getInfraInfo().getSupermarkets())
                    .build();
        }
        BuildingInfraDTO.PublicTransport publicTransport = new BuildingInfraDTO.PublicTransport();
        if(building.getInformation().getTrafficInfo() != null){
            publicTransport = BuildingInfraDTO.PublicTransport.builder()
                    .bus(building.getInformation().getTrafficInfo().getBus())
                    .subways(building.getInformation().getTrafficInfo().getSubway())
                    .build();
        }
        BuildingInfraDTO.RealCost realCost = new BuildingInfraDTO.RealCost();
        if(building.getInformation().getPriceInfo() != null){
            realCost = BuildingInfraDTO.RealCost.builder()
                    .buy(building.getInformation().getPriceInfo().getSaleAvg())
                    .longterm(building.getInformation().getPriceInfo().getLeaseAvg())
                    .monthly(building.getInformation().getPriceInfo().getRentAvg())
                    .build();
        }

        Integer safetyGrade = building.getInformation().getSecurityInfo().getSafetyGrade() == null ? 0 : building.getInformation().getSecurityInfo().getSafetyGrade();

        Double realPrice = building.getInformation().getPriceInfo().getSaleAvg();
        Double archArea = building.getInformation().getBuildingInfo().getArchArea();

        return BuildingInfraDTO.builder()
                .infras(infra)
                .publicTransport(publicTransport)
                .realCost(realCost)
                .pricePerPyeong(realPrice != null && archArea != null ? setPricePerPyeong(realPrice, archArea) : 0)
                .safetyGrade(safetyGrade)
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
            Double realPrice = buildingEntity.getInformation().getPriceInfo().getSaleAvg();
            Double archArea = buildingEntity.getInformation().getBuildingInfo().getArchArea();
            recommendAiDTOS.add(RecommendAiDTO.builder()
                            .address(buildingEntity.getNewPlatPlc())
                            .aiScore(buildingEntity.getScore())
                            .pricePerRegion(sigungu != null && realPrice != null ? setPricePerRegion(sigungu, realPrice) : 0.0)
                            .pricePerPyeong(realPrice != null && archArea != null ? setPricePerPyeong(realPrice, archArea) : 0)
                            .realPrice(realPrice)
                            .reviewCnt(reviewCnt)
                    .build());
        }

        return recommendAiDTOS;
    }

    //지역대비가격 (%)
    private Double setPricePerRegion(String sigungu, Double realPrice){
        //시군구로 같은 지역에 있는 데이터 지역 평균 가격 대비 현재 집의 백분율
        Double avgPriceByAllRegion = 3000D;
        Double pricePerRegion = (realPrice / avgPriceByAllRegion) * 100;

        return pricePerRegion;
    }
    //평당 가격
    private Integer setPricePerPyeong(Double realPrice, Double archArea){
        //1평 = 3.30579
        Double pyeongArea = archArea / 3.30579 ;
        Integer pricePerPyeong = (int) (realPrice / pyeongArea);

        return pricePerPyeong;
    }

    public List<RecommendDTO> getRecommendNearby(Double lat, Double lng){
        // 가장 가까운 거주지 중 리뷰가 있는 2개의 거주지에서 가장 최근의 리뷰 하나씩 총 2개


        return null;
    }

}
