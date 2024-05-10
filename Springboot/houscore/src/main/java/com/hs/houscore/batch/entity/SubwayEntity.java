package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "subway")
@Data
@AllArgsConstructor
public class SubwayEntity {
    //공공데이터 - 지하철
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String stationName;
    private String stationLineName;
    private Double latitude;
    private Double longitude;
    private String platPlc;
}
