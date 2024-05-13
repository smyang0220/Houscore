package com.hs.houscore.postgre.service;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.dto.ReviewDTO;
import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.repository.BuildingRepository;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.ReviewRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

import static com.hs.houscore.postgre.entity.ReviewEntity.ResidenceFloor.fromFloorNumber;
import static com.hs.houscore.postgre.entity.ReviewEntity.ResidenceType.fromString;

@Service
@Transactional
@RequiredArgsConstructor
public class ReviewService {
    private final ReviewRepository reviewRepository;
    private final BuildingRepository buildingRepository;

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
    public void setReview(ReviewDTO review, String memberEmail) {
        // 유효성 검사
        if (review == null || memberEmail == null) {
            throw new IllegalArgumentException("리뷰 데이터가 올바르지 않습니다.");
        }
        //buildingId 세팅
        BuildingEntity building = buildingRepository.findByNewPlatPlcOrPlatPlc(review.getAddress(), review.getAddress())
                .orElseThrow(() -> new IllegalArgumentException("해당 리뷰가 존재하지 않습니다."));

        ReviewEntity reviewEntity = ReviewEntity.builder()
                .memberId(memberEmail)
                .address(review.getAddress())
                .residenceType(fromString(review.getResidenceType()))
                .year(review.getResidenceYear())
                .residenceFloor(fromFloorNumber(review.getResideceFloor()))
                .starRating(ReviewEntity.StarRating.builder()
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
                .build();
        // 데이터 저장
        try {
            reviewRepository.save(reviewEntity);
        } catch (Exception e) {
            // 데이터 저장 중 예외 발생시 예외 처리
            throw new RuntimeException("리뷰 등록을 실패했습니다.", e);
        }
    }

    public void updateReview(ReviewDTO review, String memberEmail){
        ReviewEntity reviewEntity = reviewRepository.findByIdAndMemberId(review.getId(), memberEmail).orElse(null);

        if(reviewEntity == null){
            throw new IllegalArgumentException("수정 가능한 리뷰가 없습니다.");
        }

        ReviewEntity updateReviewEntity = ReviewEntity.builder()
                .id(reviewEntity.getId())
                .memberId(memberEmail)
                .address(reviewEntity.getAddress())
                .residenceType(fromString(review.getResidenceType()))
                .year(review.getResidenceYear())
                .residenceFloor(fromFloorNumber(review.getResideceFloor()))
                .starRating(ReviewEntity.StarRating.builder()
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
                .build();

        try {
            reviewRepository.save(updateReviewEntity);
        } catch (Exception e) {
            // 데이터 저장 중 예외 발생시 예외 처리
            throw new RuntimeException("리뷰 등록을 실패했습니다.", e);
        }

    }

    public void deleteReview(Long id, String memberEmail){
        //해당 리뷰를 작성한 사용자가 맞는지 검증 후 삭제
        reviewRepository.findByIdAndMemberId(id, memberEmail)
                .map(reviewEntity -> {
                    reviewRepository.delete(reviewEntity);
                    return reviewEntity;
                })
                .orElseThrow(() -> new IllegalArgumentException("해당 데이터가 존재 하지 않습니다."));
    }
}
