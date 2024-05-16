package com.hs.houscore.controller;

import com.hs.houscore.dto.*;
import com.hs.houscore.mongo.service.BuildingService;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.response.ErrorResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<?> getBuildingDetail(@RequestParam String address,
                                               @RequestParam Double lat, @RequestParam Double lng){
        try {
            BuildingDetailDTO buildingDetailDTO = buildingService.getBuildingByAddress(address,lat, lng);
            if(buildingDetailDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getBuildingByAddress NullException"));
            }
            return ResponseEntity.ok(buildingDetailDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getBuildingByAddress failure"));
        }
    }

    @GetMapping("/detail/indicator")
    @Operation(summary = "건물 상세 지표 검색", description = "주소 기반으로 건물 상세 지표 검색")
    public ResponseEntity<?> getBuildingIndicator(@RequestParam String address){
        try {
            BuildingInfraDTO buildingInfraDTO = buildingService.getBuildingInfra(address);
            if(buildingInfraDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getBuildingInfra NullException"));
            }
            return ResponseEntity.ok(buildingInfraDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getBuildingInfra failure"));
        }
    }

    @GetMapping("/review")
    @Operation(summary = "건물 리뷰 정보", description = "건물 리뷰 정보 검색")
    public ResponseEntity<?> getBuildingReview(@RequestParam(name = "address") String address
            , @RequestParam(name = "page")Integer page, @RequestParam(name = "size")Integer size){
        try {
            BuildingReviewDTO buildingReviewDTO = buildingService.getBuildingReviewList(address, page, size);
            if(buildingReviewDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getBuildingReviewList NullException"));
            }
            return ResponseEntity.ok(buildingReviewDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getBuildingReviewList failure"));
        }
    }

    @GetMapping("/main/ai")
    @Operation(summary = "AI 추천 거주지 조회", description = "AI 추천 거주지 조회 (1위~5위)")
    public ResponseEntity<?> getMainAiScoreTop5(@RequestParam String sigungu){
        try {
            List<RecommendAiDTO> recommendAiDTOS = buildingService.getMainAiScoreTop5(sigungu);
            if(recommendAiDTOS == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainAiScoreTop5 NullException"));
            } else if (recommendAiDTOS.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainAiScoreTop5 is Empty"));
            }
            return ResponseEntity.ok(recommendAiDTOS);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainAiScoreTop5 failure"));
        }
    }

    @GetMapping("/main/nearby")
    @Operation(summary = "근처 거주지 최근 리뷰 조회", description = "가장 가까운 거주지 중 리뷰가 있는 2개의 거주지에서 가장 최근의 리뷰 하나씩 총 2개")
    public ResponseEntity<?> getMainNearby(@RequestParam Double lat, @RequestParam Double lng){
        try {
            List<MainPageDTO> mainPageDTOS = buildingService.getMainNearby(lat,lng);
            if(mainPageDTOS == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainNearby NullException"));
            } else if (mainPageDTOS.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainNearby is Empty"));
            }
            return ResponseEntity.ok(mainPageDTOS);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainNearby failure"));
        }
    }

    @GetMapping("/main/photo")
    @Operation(summary = "생생한 사진 후기 조회", description = "사진이 등록된 리뷰들 중 가장 최근이나 좋은 리뷰를 받은 순으로 조회")
    public ResponseEntity<?> getMainPhoto() {
        try {
            List<MainPageDTO> mainPageDTOS = buildingService.getMainPhoto();
            if(mainPageDTOS == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainPhoto NullException"));
            } else if (mainPageDTOS.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainPhoto is Empty"));
            }
            return ResponseEntity.ok(mainPageDTOS);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMainPhoto failure"));
        }
    }
}
