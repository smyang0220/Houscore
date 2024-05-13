package com.hs.houscore.controller;

import com.hs.houscore.dto.*;
import com.hs.houscore.response.ErrorResponse;
import com.hs.houscore.s3.S3UploadService;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.service.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Base64;
import java.util.List;

@RestController
@RequestMapping("/api/review")
public class ReviewController {

    private final ReviewService reviewService;
    private final S3UploadService s3UploadService;

    @Autowired
    public ReviewController(ReviewService reviewService, S3UploadService s3UploadService) {
        this.reviewService = reviewService;
        this.s3UploadService = s3UploadService;
    }

    @GetMapping("")
    @Operation(summary = "리뷰 상세 내용", description = "리뷰 상세 내용 조회")
    public ResponseEntity<?> getReview(@RequestParam Long id) {
        try {
            ReviewEntity reviewEntity = reviewService.getDetailReview(id);
            if(reviewEntity == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getDetailReview NullException"));
            }
            return ResponseEntity.ok(reviewEntity);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getDetailReview failure"));
        }
    }

    @GetMapping("recent")
    @Operation(summary = "최근 리뷰 리스트", description = "최근 리뷰 리스트 조회")
    public ResponseEntity<?> getRecentReviews(){
        try {
            List<ReviewEntity> reviewEntities = reviewService.getRecentReviews();
            if(reviewEntities == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getRecentReviews NullException"));
            }else if (reviewEntities.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getRecentReviews is Empty"));
            }
            return ResponseEntity.ok(reviewEntities);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getRecentReviews failure"));
        }
    }

    @GetMapping("my-review")
    @Operation(summary = "내가 쓴 리뷰 리스트", description = "내가 쓴 리뷰 리스트 조회")
    public ResponseEntity<?> getMyReviews(@AuthenticationPrincipal String memberEmail){
        try {
            //유저 검증
            if(memberEmail == null || memberEmail.equals("anonymousUser")){
                return ResponseEntity.badRequest().body(new ErrorResponse("사용자 검증 필요"));
            }

            List<ReviewEntity> reviewEntities = reviewService.getMyReviews(memberEmail);
            if(reviewEntities == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMyReviews NullException"));
            }else if (reviewEntities.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMyReviews is Empty"));
            }
            return ResponseEntity.ok(reviewEntities);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMyReviews failure"));
        }
    }

    @PostMapping("")
    @Operation(summary = "거주지 리뷰 등록", description = "거주지 리뷰 등록")
    public ResponseEntity<?> addReview(@RequestBody CreateReviewDTO review,
                                       @AuthenticationPrincipal String memberEmail,
                                       @RequestParam @Parameter(description = "image : 인코딩 되지 않은 이미지 ") String image,
                                       @RequestParam @Parameter(description = "imageName : 이미지 이름(임의로 지정)") String imageName) {
        try{
            //유저 검증
            if(memberEmail == null || memberEmail.equals("anonymousUser")){
                return ResponseEntity.badRequest().body(new ErrorResponse("사용자 검증 필요"));
            }

            // 이미지 데이터를 Base64로 인코딩
            String imageBase64 = Base64.getEncoder().encodeToString(image.getBytes());

            // FileUploadDTO 세팅
            FileUploadDTO fileUploadDTO = new FileUploadDTO();
            fileUploadDTO.setImageBase64(imageBase64);
            fileUploadDTO.setImageName(imageName);

            // S3 이미지 업로드
            String result = s3UploadService.saveImage(fileUploadDTO);
            review.setImages(result);

            reviewService.setReview(review, memberEmail);
            return ResponseEntity.status(HttpStatus.CREATED).body("리뷰 등록 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 리뷰 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 등록 실패!");
        }
    }

    @PutMapping("")
    @Operation(summary = "거주지 리뷰 수정", description = "거주지 리뷰 수정")
    public ResponseEntity<?> updateReview(@RequestBody ReviewDTO review,
                                          @AuthenticationPrincipal String memberEmail) {
        try{
            //유저 검증
            if(memberEmail == null || memberEmail.equals("anonymousUser")){
                return ResponseEntity.badRequest().body(new ErrorResponse("사용자 검증 필요"));
            }

            reviewService.updateReview(review, memberEmail);
            return ResponseEntity.status(HttpStatus.CREATED).body("리뷰 수정 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 리뷰 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 수정 실패!");
        }
    }

    @DeleteMapping("")
    @Operation(summary = "거주지 리뷰 삭제", description = "거주지 리뷰 삭제")
    public ResponseEntity<?> deleteReview(@RequestParam Long id,
                                          @AuthenticationPrincipal String memberEmail) {
        try {
            //유저 검증
            if(memberEmail == null || memberEmail.equals("anonymousUser")){
                return ResponseEntity.badRequest().body(new ErrorResponse("사용자 검증 필요"));
            }

            reviewService.deleteReview(id, memberEmail);
            return ResponseEntity.status(HttpStatus.OK).body("리뷰 삭제 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 리뷰 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 삭제 실패!");
        }
    }
}
