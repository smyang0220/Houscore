package com.hs.houscore.postgre.service;

import com.hs.houscore.dto.BuildingReviewDTO;
import com.hs.houscore.dto.CreateReviewDTO;
import com.hs.houscore.dto.ReviewDTO;
import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.repository.BuildingRepository;
import com.hs.houscore.mongo.service.BuildingService;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.ReviewRepository;
import com.hs.houscore.s3.S3UploadService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import static com.hs.houscore.postgre.entity.ReviewEntity.ResidenceFloor.fromFloorNumber;
import static com.hs.houscore.postgre.entity.ReviewEntity.ResidenceType.fromString;

@Service
@Transactional
@RequiredArgsConstructor
public class ReviewService {
    private final ReviewRepository reviewRepository;
    private final BuildingRepository buildingRepository;
    private final BuildingService buildingService;
    private final S3UploadService s3UploadService;

    //리뷰 전체 조회
    public BuildingReviewDTO getReviewList(int page, int size){
        System.out.println("dd");
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "createdAt"));
        Page<ReviewEntity> reviewEntities = reviewRepository.findAll(pageable);
        Long reviewAllCnt = reviewRepository.countAllBy();

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
                        .count(reviewAllCnt)
                        .build())
                .data(buildingReviewDTOS)
                .build();
    }

    //리뷰 상세
    public ReviewEntity getDetailReview(Long id){
        return reviewRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("해당 리뷰가 존재하지 않습니다."));
    }

    //최근 리뷰 리스트
    public List<ReviewEntity> getRecentReviews(){
        return reviewRepository.findTop10ByOrderByCreatedAt();
    }

    //내가 쓴 리뷰 리스트
    public List<ReviewEntity> getMyReviews(String memberEmail) {
        return reviewRepository.findByMemberIdOrderByCreatedAt(memberEmail);
    }

    //리뷰 등록
    public void setReview(CreateReviewDTO review, String memberEmail) {
        // 유효성 검사
        if (review == null || memberEmail == null) {
            throw new IllegalArgumentException("리뷰 데이터가 올바르지 않습니다.");
        }
        //buildingId 값이 없을 때 buildingEntity 생성하고 저장한 후 리뷰등록
        BuildingEntity building = buildingRepository.findByNewPlatPlcOrPlatPlc(review.getAddress(), review.getAddress()).orElse(null);
        if(building == null){
            //buildingEntity 저장
            buildingService.getBuildingByAddress(review.getAddress(), review.getLat(), review.getLng());
        }

        ReviewEntity reviewEntity = ReviewEntity.builder()
                .memberId(memberEmail)
                .address(review.getAddress())
                .residenceType(fromString(review.getResidenceType()))
                .year(review.getResidenceYear())
                .residenceFloor(fromFloorNumber(review.getResidenceFloor()))
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
        if(review.getImageChange().equals("y")){
            //기존의 이미지 삭제
            String result = s3UploadService.deleteImage(reviewEntity.getImages());
            System.out.println(result);
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
                    //기존의 이미지 삭제
                    String result = s3UploadService.deleteImage(reviewEntity.getImages());
                    System.out.println(result);

                    reviewRepository.delete(reviewEntity);
                    return reviewEntity;
                })
                .orElseThrow(() -> new IllegalArgumentException("해당 데이터가 존재 하지 않습니다."));
    }
}
