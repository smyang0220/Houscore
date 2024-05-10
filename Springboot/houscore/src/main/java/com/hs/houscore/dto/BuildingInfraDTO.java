package com.hs.houscore.dto;

import lombok.*;

import java.io.Serializable;
import java.util.List;
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
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Infras {
        private List<Map<String, Object>> medicalFacilities;
        private List<Map<String, Object>> park;
        private List<Map<String, Object>> school;
        private List<Map<String, Object>> library;
        private List<Map<String, Object>> supermarket;
    }
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PublicTransport {
        private List<Map<String, Object>> bus;
        private List<Map<String, Object>> subways;
    }
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RealCost{
        private Double buy;
        private Double longterm;
        private String monthly;
    }
}
