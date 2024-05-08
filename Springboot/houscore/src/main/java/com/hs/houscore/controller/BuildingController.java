package com.hs.houscore.controller;

import com.hs.houscore.dto.BuildingDetailDTO;
import com.hs.houscore.dto.BuildingInfraDTO;
import com.hs.houscore.dto.RecommendAiDTO;
import com.hs.houscore.dto.RecommendDTO;
import com.hs.houscore.mongo.service.BuildingService;
import com.hs.houscore.postgre.entity.ReviewEntity;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/residence")
@Tag(name = "건물 컨트롤러", description = "건물 관련 컨트롤러")
public class BuildingController {
    private final BuildingService buildingService;

    @Autowired
    public BuildingController(BuildingService buildingService) {
        this.buildingService = buildingService;
    }

    @GetMapping("/detail")
    @Operation(summary = "건물 상세 검색", description = "주소 기반으로 건물 상세 정보 검색")
    public BuildingDetailDTO getBuildingDetail(@RequestParam String address,
                                               @RequestParam Double lat, @RequestParam Double lng){
        return buildingService.getBuildingByAddress(address,lat,lng);
    }

    @GetMapping("/detail/indicator")
    @Operation(summary = "건물 상세 지표 검색", description = "주소 기반으로 건물 상세 지표 검색")
    public BuildingInfraDTO getBuildingIndicator(@RequestParam String address){
        return buildingService.getBuildingInfra(address);
    }

    @GetMapping("/review")
    @Operation(summary = "건물 리뷰 정보", description = "건물 리뷰 정보 검색")
    public List<ReviewEntity> getBuildingReview(@RequestParam String address){
        return buildingService.getBuildingReviewList(address);
    }

    @GetMapping("/recommend/ai")
    @Operation(summary = "AI 추천 거주지 조회 ", description = "AI 추천 거주지 조회 (1위~5위)")
    public List<RecommendAiDTO> getRecommendAiScoreTop5(@RequestParam String sigungu){
        return buildingService.getRecommendAiScoreTop5(sigungu);
    }

    @GetMapping("/recommend/nearby")
    @Operation(summary = "근처 거주지 최근 리뷰 조회 ", description = "가장 가까운 거주지 중 리뷰가 있는 2개의 거주지에서 가장 최근의 리뷰 하나씩 총 2개")
    public List<RecommendDTO> getRecommendNearby(@RequestParam Double lat, @RequestParam Double lng){
        return buildingService.getRecommendNearby(lat,lng);
    }
}
