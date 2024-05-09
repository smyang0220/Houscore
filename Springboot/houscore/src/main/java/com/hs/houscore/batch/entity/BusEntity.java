package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "bus")
@Data
@AllArgsConstructor
public class BusEntity {
    //공공데이터 - 버스
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String busStopName;
    private Double latitude;
    private Double longitude;
}
