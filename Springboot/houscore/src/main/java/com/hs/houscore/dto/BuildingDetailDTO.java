package com.hs.houscore.dto;


import lombok.*;

@Data
@Builder
public class BuildingDetailDTO {
    private Long id;
    private Double score;
    private Double lat;
    private Double lng;
    private String platPlc;
    private String newPlatPlc;
    private BuildingInfo buildingInfo;

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
    }
}
