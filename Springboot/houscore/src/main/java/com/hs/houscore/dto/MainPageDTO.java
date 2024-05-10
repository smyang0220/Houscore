package com.hs.houscore.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MainPageDTO {
    private String buildingName;
    private String address;
    private String pros;
    private String cons;
    private Double reviewScore;
    private Double aiScore;
    private String imageUrl;
}
