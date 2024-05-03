package com.hs.houscore.mongo.entity;


import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "building")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class BuildingEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Double score;
    private Double lat;
    private Double lng;
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
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Builder
    public static class BuildingInfo {
        private String mgmBldrgstPk;
        private String etcPurps;
        private String mainPurpsCdNm;
        private String mainAtchGbCdNm;
        private Integer hhldCnt;
        private Double heit;
        private Integer grndFlrCnt;
        private Integer ugrndFlrCnt;
        private Integer rideUseElvtCnt;
        private Integer parkingCnt;
        private String pmsDay;
        private String stcnsDay;
        private String useAprDay;
        private String bldNm;
        private String dongNm;
        private Double platArea;
        private Double archArea;
        private Double totArea;
        private Double bcRat;
        private Double vlRat;
        private String strctCdNm;
        private Integer rserthqkDsgnApplyYn;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class InfraInfo {
        private Integer parkCnt;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class SecurityInfo {
        private Integer safetyGrade;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class TrafficInfo {
        private Integer bus;
        private Integer subway;
    }
}
