package com.hs.houscore.dto;

import lombok.*;

import java.util.Map;

@Data
@Builder
public class BuildingInfraDTO {
    private Infras infras;
    private PublicTransport publicTransport;
    private RealCost realCost;
    private Integer pricePerPyeong;
    private Integer safetyGrade;

    @Data
    @Builder
    public static class Infras {
        private Map<String, Long> medicalFacilities;
        private Map<String, Long> parks;
        private Map<String, Long> schools;
        private Map<String, Long> libraries;
        private Map<String, Long> supermarkets;
    }
    @Data
    @Builder
    public static class PublicTransport {
        private Map<String, Long> bus;
        private Map<String, Long> subways;
    }
    @Data
    @Builder
    public static class RealCost{
        private Double buy;
        private Double longterm;
        private String monthly;
    }

}
