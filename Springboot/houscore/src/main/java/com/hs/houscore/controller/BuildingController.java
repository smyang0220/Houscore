package com.hs.houscore.controller;

import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.service.BuildingService;
import com.hs.houscore.postgre.entity.ReviewEntity;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/building")
@Tag(name = "건물 컨트롤러", description = "건물 관련 컨트롤러")
public class BuildingController {
    private final BuildingService buildingService;

    @Autowired
    public BuildingController(BuildingService buildingService) {
        this.buildingService = buildingService;
    }

    @GetMapping("/detail")
    @Operation(summary = "건물 상세 검색", description = "주소 기반으로 건물 상세 정보 검색")
    public BuildingEntity getBuildingDetail(@RequestParam String address){
        return buildingService.getBuildingByAddress(address);
    }

    @GetMapping("/detail/indicator")
    @Operation(summary = "건물 상세 지표 검색", description = "주소 기반으로 건물 상세 지표 검색")
    public BuildingEntity getBuildingIndicator(@RequestParam String address){
        return buildingService.getBuildingByAddress(address);
    }

    @GetMapping("/review")
    @Operation(summary = "건물 리뷰 정보", description = "건물 리뷰 정보 검색")
    public List<ReviewEntity> getBuildingReview(@RequestParam String address){
        return buildingService.getBuildingReviewList(address);
    }
}
