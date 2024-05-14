package com.hs.houscore.dto;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class ReviewDTO {
    private Long id;
    private String address;
    private String residenceType;
    private String resideceFloor;
    private StarRating starRating;
    private String pros;
    private String cons;
    private String maintenanceCost;
    private String images;
    private String residenceYear;


    @Data
    public static class StarRating implements Serializable {
        private Double traffic;
        private Double building;
        private Double inside;
        private Double infra;
        private Double security;
    }

}
