package com.hs.houscore.mongo.service;

import com.hs.houscore.dto.*;
import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.repository.BuildingRepository;
import com.hs.houscore.mongo.repository.BuildingRepositoryCustom;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.ReviewRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class BuildingService {

    private final BuildingRepository buildingRepository;
    private final ReviewRepository reviewRepository;
    private final BuildingRepositoryCustom buildingRepositoryCustom;

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
                    .park(building.getInformation().getInfraInfo().getParks())
                    .school(building.getInformation().getInfraInfo().getSchools())
                    .library(building.getInformation().getInfraInfo().getLibraries())
                    .supermarket(building.getInformation().getInfraInfo().getSupermarkets())
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

    public BuildingReviewDTO getBuildingReviewList(String address, Integer page, Integer size){
        Pageable pageable = PageRequest.of(page, size);
        Page<ReviewEntity> reviewEntities = reviewRepository.findPageByAddress(address, pageable);
        Long reviewCnt = reviewRepository.countByAddressStartingWith(address);

        List<ReviewEntity> reviews = reviewEntities.getContent();
        List<BuildingReviewDTO.Review> buildingReviewDTOS = new ArrayList<>();
        for(ReviewEntity review : reviews){
            buildingReviewDTOS.add(BuildingReviewDTO.Review.builder()
                            .id(review.getId())
                            .address(review.getAddress())
                            .residenceType(review.getResidenceType().toString())
                            .residenceFloor(review.getResidenceFloor().toString())
                            .starRating(BuildingReviewDTO.Review.StarRating.builder()
                                    .infra(review.getStarRating().getInfra())
                                    .building(review.getStarRating().getBuilding())
                                    .inside(review.getStarRating().getInside())
                                    .traffic(review.getStarRating().getTraffic())
                                    .security(review.getStarRating().getSecurity())
                                    .build())
                            .pros(review.getPros())
                            .cons(review.getCons())
                            .maintenanceCost(review.getMaintenanceCost())
                            .images(review.getImages())
                            .residenceYear(review.getYear())
                    .build());
        }

        return BuildingReviewDTO.builder()
                .meta(BuildingReviewDTO.Meta.builder()
                        .count(reviewCnt)
                        .build())
                .data(buildingReviewDTOS)
                .build();
    }

    public List<RecommendAiDTO> getMainAiScoreTop5(String sigungu){
        List<BuildingEntity> buildingEntities = buildingRepository.findByInformationBuildingInfoSigunguCd(sigungu);
        List<RecommendAiDTO> recommendAiDTOS = new ArrayList<>();
        Double avgCost = calRegionAvg(buildingEntities);
        for(BuildingEntity buildingEntity : buildingEntities){
            Long reviewCnt = reviewRepository.countByAddressStartingWith(buildingEntity.getNewPlatPlc());
            Double realPrice = buildingEntity.getInformation().getPriceInfo().getSaleAvg();
            Double archArea = buildingEntity.getInformation().getBuildingInfo().getArchArea();
            recommendAiDTOS.add(RecommendAiDTO.builder()
                            .address(buildingEntity.getPlatPlc())
                            .aiScore(buildingEntity.getScore())
                            .pricePerRegion(realPrice != null && avgCost >= 0.0 ? (realPrice / avgCost) * 100 : 0.0)
                            .pricePerPyeong(realPrice != null && archArea != null ? setPricePerPyeong(realPrice, archArea) : 0)
                            .realPrice(realPrice)
                            .reviewCnt(reviewCnt)
                    .build());
        }

        return recommendAiDTOS;
    }

    //지역평균가격 계산
    private Double calRegionAvg(List<BuildingEntity> buildingEntities) {
        Double avgCostSum = 0.0;
        for(BuildingEntity buildingEntity : buildingEntities) {
            avgCostSum += buildingEntity.getInformation().getPriceInfo().getSaleAvg();
        }

        return avgCostSum / buildingEntities.size();
    }

    //평당 가격
    private Integer setPricePerPyeong(Double realPrice, Double archArea){
        //1평 = 3.30579
        Double pyeongArea = archArea / 3.30579 ;
        Integer pricePerPyeong = (int) (realPrice / pyeongArea);

        return pricePerPyeong;
    }

    public List<MainPageDTO> getMainNearby(Double lat, Double lng){
        List<BuildingEntity> buildingEntities = buildingRepositoryCustom.findBuildingsWithin1Km(new GeoJsonPoint(lng,lat));
        List<ReviewEntity> latestReviewEntities = new ArrayList<>();

        for(BuildingEntity buildingEntity : buildingEntities) {
            List<ReviewEntity> reviewEntities = reviewRepository.findListByAddress(buildingEntity.getPlatPlc());

            if(reviewEntities != null && !reviewEntities.isEmpty()) {
                ReviewEntity latestReview = getLatestReview(reviewEntities);
                latestReviewEntities.add(latestReview);
            }
        }

        if(latestReviewEntities.isEmpty()) return null;

        List<ReviewEntity> latestTwoReviews = getLatestTwoReviews(latestReviewEntities);
        List<MainPageDTO> mainPageDTOS = new ArrayList<>();

        for(ReviewEntity reviewEntity : latestTwoReviews) {
            Optional<BuildingEntity> buildingEntity = buildingRepository.findByNewPlatPlcOrPlatPlc(reviewEntity.getAddress(), reviewEntity.getAddress());

            buildingEntity.ifPresent(entity -> mainPageDTOS.add(MainPageDTO.builder()
                    .address(entity.getPlatPlc())
                    .buildingName(entity.getInformation().getBuildingInfo().getBldNm())
                    .aiScore(entity.getScore())
                    .reviewScore(calculateReviewScore(entity.getPlatPlc()))
                    .cons(reviewEntity.getCons())
                    .pros(reviewEntity.getPros())
                    .imageUrl(reviewEntity.getImages())
                    .build()));
        }
        return mainPageDTOS;
    }

    //가장 최신의 리뷰 찾기
    private ReviewEntity getLatestReview (List<ReviewEntity> reviewEntities) {
        if (reviewEntities == null || reviewEntities.isEmpty()) {
            return null;
        }

        // 최신 리뷰를 찾기 위해 createdAt 기준으로 내림차순 정렬
        return reviewEntities.stream()
                .max(Comparator.comparing(ReviewEntity::getCreatedAt))
                .orElse(null);
    }

    //가장 최신의 리뷰 2개 찾기
    private List<ReviewEntity> getLatestTwoReviews(List<ReviewEntity> reviewEntities) {
        if (reviewEntities == null || reviewEntities.isEmpty()) {
            return Collections.emptyList();
        }

        // 최신순으로 정렬 후 최상위 2개를 선택
        return reviewEntities.stream()
                .sorted(Comparator.comparing(ReviewEntity::getCreatedAt).reversed())
                .limit(2)
                .collect(Collectors.toList());
    }

    public List<MainPageDTO> getMainPhoto(){
        List<ReviewEntity> reviewEntities = reviewRepository.findAll();
        List<MainPageDTO> mainPageDTOS = new ArrayList<>();
        int reviewSize = reviewEntities.size();
        Random random = new Random();
        for(int i = 0; i < reviewSize; i++){
            int randomNumber = random.nextInt(reviewSize);
            Optional<ReviewEntity> reviewEntity = reviewRepository.findById((long) randomNumber);

            if(reviewEntity.isPresent()) {
                Optional<BuildingEntity> buildingEntity = buildingRepository.findByNewPlatPlcOrPlatPlc(reviewEntity.get().getAddress(), reviewEntity.get().getAddress());

                buildingEntity.ifPresent(entity -> mainPageDTOS.add(MainPageDTO.builder()
                        .address(entity.getPlatPlc())
                        .buildingName(entity.getInformation().getBuildingInfo().getBldNm())
                        .aiScore(entity.getScore())
                        .reviewScore(calculateReviewScore(entity.getPlatPlc()))
                        .cons(reviewEntity.get().getCons())
                        .pros(reviewEntity.get().getPros())
                        .imageUrl(reviewEntity.get().getImages())
                        .build()));
            }

            if(mainPageDTOS.size() >= 5) break;
        }

        return mainPageDTOS;
    }

    // 평균 반환 메서드
    private double calculateReviewScore (String address) {
        List<ReviewEntity> reviewEntities = reviewRepository.findListByAddress(address);

        double score = 0;
        for(ReviewEntity reviewEntity : reviewEntities){
            score += reviewEntity.getStarRatingAverage();
        }

        return score / reviewEntities.size();
    }

}
