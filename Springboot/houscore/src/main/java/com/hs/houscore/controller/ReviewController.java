package com.hs.houscore.controller;

import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.service.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/review")
public class ReviewController {

    private final ReviewService reviewService;

    @Autowired
    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
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
    @Operation(summary = "거주지 리뷰 등록", description = "거주리 리뷰 등록")
    public ResponseEntity<?> addReview(@RequestBody ReviewEntity review) {
        try{
            ReviewEntity savedReview = reviewService.setReview(review);
            return ResponseEntity.status(HttpStatus.CREATED).body("리뷰 등록 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 리뷰 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 등록 실패!");
        }
    }

    @PutMapping("")
    @Operation(summary = "거주지 리뷰 수정", description = "거주리 리뷰 수정")
    public ResponseEntity<?> updateReview(@RequestBody ReviewEntity review) {
        try{
            ReviewEntity updateReview = reviewService.updateReview(review);
            return ResponseEntity.status(HttpStatus.CREATED).body("리뷰 수정 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 리뷰 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 수정 실패!");
        }
    }

    @DeleteMapping("")
    @Operation(summary = "거주지 리뷰 삭제", description = "거주리 리뷰 삭제")
    public ResponseEntity<?> deleteReview(@RequestParam Long id) {
        reviewService.deleteReview(id);
        return ResponseEntity.status(HttpStatus.OK).body("리뷰 삭제 성공");
    }
}
