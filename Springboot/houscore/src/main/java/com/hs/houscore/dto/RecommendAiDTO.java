package com.hs.houscore.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RecommendAiDTO {
    private String address;
    private Double aiScore;
    private Double realPrice;   //만원 단위
    private Double pricePerPyeong;
    private Double pricePerRegion ; //지역대비가격 %
    private Long reviewCnt;
}