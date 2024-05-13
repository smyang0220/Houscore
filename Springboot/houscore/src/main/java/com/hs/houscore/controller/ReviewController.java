package com.hs.houscore.controller;

import com.hs.houscore.dto.FileUploadDTO;
import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.dto.ReviewDTO;
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
    public ReviewEntity getReview(@RequestParam Long id) {
        return reviewService.getDetailReview(id);
    }

    @GetMapping("recent")
    @Operation(summary = "최근 리뷰 리스트", description = "최근 리뷰 리스트 조회")
    public List<ReviewEntity> getRecentReviews(){
        return reviewService.getRecentReviews();
    }

    @GetMapping("my-review")
    @Operation(summary = "내가 쓴 리뷰 리스트", description = "내가 쓴 리뷰 리스트 조회")
    public List<ReviewEntity> getMyReviews(@RequestParam String memberId){
        return reviewService.getMyReviews(memberId);
    }

    @PostMapping("")
    @Operation(summary = "거주지 리뷰 등록", description = "거주지 리뷰 등록")
    public ResponseEntity<?> addReview(@RequestBody ReviewDTO review,
                                       @AuthenticationPrincipal MemberDTO member,
                                       @RequestParam @Parameter(description = "imageBase64 : 인코딩 되지 않은 이미지 ") String imageBase64,
                                       @RequestParam @Parameter(description = "imageName : 이미지 이름(임의로 지정)") String imageName) {
        try{
            // 이미지 데이터를 Base64로 인코딩
            String encodedImageBase64 = Base64.getEncoder().encodeToString(imageBase64.getBytes());

            // FileUploadDTO 세팅
            FileUploadDTO fileUploadDTO = new FileUploadDTO();
            fileUploadDTO.setImageBase64(encodedImageBase64);
            fileUploadDTO.setImageName(imageName);

            // S3 이미지 업로드
            String result = s3UploadService.saveImage(fileUploadDTO);
            review.setImages(result);

            reviewService.setReview(review, member);
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
                                          @AuthenticationPrincipal MemberDTO member) {
        try{
            reviewService.updateReview(review, member);
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
                                          @AuthenticationPrincipal MemberDTO member) {
        reviewService.deleteReview(id, member);
        return ResponseEntity.status(HttpStatus.OK).body("리뷰 삭제 성공");
    }
}
