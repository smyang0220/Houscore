package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "store")
@Data
@AllArgsConstructor
public class StoreEntity {
    //공공데이터 - 상점(마트)
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String platPlc;
    private String newPlatPlc;
    private String storeName;
    private Double latitude;
    private Double longitude;
}
