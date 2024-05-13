package com.hs.houscore.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
public class BuildingReviewDTO {
    private Meta meta;
    private List<Review> data;

    @Data
    @Builder
    public static class Meta {
        private Long count;
    }

    @Data
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Review {
        private Long id;
        private String address;
        private String residenceType;
        private String residenceFloor;
        private Review.StarRating starRating;
        private String pros;
        private String cons;
        private String maintenanceCost;
        private String images;
        private String residenceYear;


        @Data
        @Builder
        public static class StarRating {
            private Double traffic;
            private Double building;
            private Double inside;
            private Double infra;
            private Double security;

            public double average() {
                return (traffic + building + inside + infra + security) / 5.0;
            }
        }
    }
}
