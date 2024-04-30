package com.hs.houscore.postgre.service;

import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.ReviewRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ReviewService {
    private final ReviewRepository reviewRepository;

    //리뷰 상세
    public ReviewEntity getDetailReview(Long id){
        return reviewRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("해당 리뷰가 존재하지 않습니다."));
    }

    //최근 리뷰 리스트
    public List<ReviewEntity> getRecentReviews(){
        return reviewRepository.findTop10ByOrderByCreatedAt();
    }

    //내가 쓴 리뷰 리스트
    public List<ReviewEntity> getMyReviews(String memberId) {
        return reviewRepository.findByMemberIdOrderByCreatedAt(memberId);
    }

    //리뷰 등록
    public void setReview(ReviewEntity review) {
        // 유효성 검사
        if (review == null || review.getMemberId() == null || review.getBuildingId() == null) {
            throw new IllegalArgumentException("리뷰 데이터가 올바르지 않습니다.");
        }

        // 데이터 저장
        try {
            reviewRepository.save(review);
        } catch (Exception e) {
            // 데이터 저장 중 예외 발생시 예외 처리
            throw new RuntimeException("리뷰 등록을 실패했습니다.", e);
        }
    }

    public void updateReview(ReviewEntity review){
        ReviewEntity reviewEntity = reviewRepository.findByIdAndMemberId(review.getId(), review.getMemberId()).orElse(null);

        if(reviewEntity == null){
            throw new IllegalArgumentException("수정 가능한 리뷰가 없습니다.");
        }
        try {
            reviewRepository.save(review);
        } catch (Exception e) {
            // 데이터 저장 중 예외 발생시 예외 처리
            throw new RuntimeException("리뷰 등록을 실패했습니다.", e);
        }

    }

    public void deleteReview(Long id){
        reviewRepository.findById(id)
                .map(reviewEntity -> {
                    reviewRepository.delete(reviewEntity);
                    return reviewEntity;
                })
                .orElseThrow(() -> new IllegalArgumentException("해당 데이터가 존재 하지 않습니다."));
    }
}
