package com.hs.houscore.mongo.entity;


import lombok.*;
import org.bson.types.ObjectId;
import org.hibernate.annotations.Type;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.core.mapping.Document;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

@Document(collection = "building")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class BuildingEntity {
//    @Transient
//    public static final String SEQUENCE_NAME = "bulding_sequence";

    @Id
    private ObjectId id;
    @Setter
    private Double score;
    private GeoJsonPoint location;
//    private Double lat;
//    private Double lng;
    private String platPlc;
    private String newPlatPlc;

    private String batchYn;
    private Information information;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Builder
    public static class Information {
        private BuildingInfo buildingInfo;
        private InfraInfo infraInfo;
        private SecurityInfo securityInfo;
        private TrafficInfo trafficInfo;
        private PriceInfo priceInfo;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Builder
    public static class BuildingInfo {
        private Double platArea;        //대지면적
        private Double archArea;        //건축면적
        private Double totArea;         //연면적
        private Double bcRat;           //건폐율
        private Double vlRat;           //용적률
        private String mainPurpsCdNm;   //주용도코드명
        private Integer regstrKindCd;   //대장종류코드
        private String regstrKindCdNm;  //대장종류코드명
        private Integer hhldCnt;        //세대수
        private Integer mainBldCnt;     //주건축물수
        private Integer totPkngCnt;     //총주차수
        private String sigunguCd;
        private String bjdongCd;
        private String bldNm;
        private String pnuCode;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Builder
    public static class InfraInfo {
        private List<Map<String, Object>> medicalFacilities;
        private List<Map<String, Object>> parks;
        private List<Map<String, Object>> schools;
        private List<Map<String, Object>> libraries;
        private List<Map<String, Object>> supermarkets;
        private List<Map<String, Object>> laundry;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Builder
    public static class SecurityInfo {
        private Integer safetyGrade;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Builder
    public static class TrafficInfo {
        private List<Map<String, Object>> bus;
        private List<Map<String, Object>> subway;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Builder
    public static class PriceInfo {
        private Long leaseAvg;        //평균 전세가격
        private String rentAvg;         //평균 월세가격
        private Long saleAvg;         //평균 매매가
        private Long[] individualPubliclyAnnouncedPrice; //공시지가
    }

}
