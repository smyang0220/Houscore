package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "school")
@Data
@AllArgsConstructor
public class SchoolEntity {
    //공공데이터 - 학교
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String schoolName;
    private String schoolType;
    private String platPlc;
    private String newPlatPlc;
    private Double latitude;
    private Double longitude;
}
