package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "laundry")
@Data
@AllArgsConstructor
public class LaundryEntity {
    //공공데이터 - 세탁소
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String platPlc;
    private String newPlatPlc;
    private String laundryName;
    private Double latitude;
    private Double longitude;
}
