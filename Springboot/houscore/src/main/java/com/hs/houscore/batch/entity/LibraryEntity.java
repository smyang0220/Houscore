package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "library")
@Data
@AllArgsConstructor
public class LibraryEntity {
    //공공데이터 - 도서관
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String libraryName;
    private String newPlatPlc;
    private Double latitude;
    private Double longitude;
}
