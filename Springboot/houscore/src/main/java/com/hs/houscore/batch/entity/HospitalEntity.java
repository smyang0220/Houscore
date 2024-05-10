package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "hospital")
@Data
@AllArgsConstructor
public class HospitalEntity {
    //공공데이터 - 병원
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String hospitalName;
    private String hospitalType;
    private String platPlc;
    private Double latitude;
    private Double longitude;
    private String diagnosisType;
}
