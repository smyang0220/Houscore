package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "safe_rank")
@Data
@AllArgsConstructor
public class SafeRankEntity {
    //공공데이터 - 안전등급
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String area;
    private Integer crimeRank;
    private String sigunguCode;
}
