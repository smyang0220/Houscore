package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "park")
@Data
@AllArgsConstructor
public class ParkEntity {
    //공공데이터 - 공원
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String parkName;
    private String platPlc;
    private Double latitude;
    private Double longitude;
}
