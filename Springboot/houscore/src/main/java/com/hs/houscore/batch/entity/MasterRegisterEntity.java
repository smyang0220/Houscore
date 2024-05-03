package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "master_register")
@Data
@AllArgsConstructor
public class MasterRegisterEntity {
    //공공데이터 - 건물 표제부 테이블
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private Double platArea;    //대지면적(㎡)
    private Double archArea;    //건축면적(㎡)
    private Double bcRat;       //건폐율(%)
    private Double totArea;     //연면적(㎡)
    private Double vlRat;       //용적률(%)
    private String mainPurpsCdNm;       //주용도코드명
    private Integer regstrKindCd;       //대장종류코드
    private String regstrKindCdNm;      //대장종류코드명
    private Integer hhldCnt;    //세대수(세대)
    private Integer mainBldCnt; //주건축물수
    private Integer totPkngCnt; //총주차수
    private String platPlc;     //대지위치
    private String sigunguCd;   //시군구코드
    private String bjdongCd;    //법정동코드
    private String newPlatPlc;  //도로명대지위치
    private String bldNm;       //건물명
    private String pnuCode;     //(시군구코드+법정동코드+대지구분코드+번(4자리) + 지(4자리))
    private Date crtnDay;       //생성일
//    허가일	pmsDay
//    착공일	stcnsDay
//    사용승인일	useAprDay

}
