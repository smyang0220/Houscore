package com.hs.houscore.postgre.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.io.Serializable;
import java.util.Date;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Data
@Builder
@Getter
@Table(name = "review")
public class ReviewEntity {
    @Id
    @GeneratedValue (strategy = GenerationType.SEQUENCE)
    private Long id;
    private String memberId;
    private Long buildingId;
    private String address;
    private ResidenceType residenceType;
    private Integer year;
    private ResidenceFloor residenceFloor;
    @JdbcTypeCode(SqlTypes.JSON)
    private StarRating starRating;
    private String pros;
    private String cons;
    private String maintenanceCost;
    private String images;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt; // 생성 날짜

    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt; // 업데이트 날짜

    // 엔티티가 영속성 컨텍스트에 저장되기 전에 호출됩니다.
    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
    }

    // 엔티티가 영속성 컨텍스트에 merge 될 때 호출됩니다.
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = new Date();
    }


    public enum ResidenceType {
        VILLA, APT, OFFICETEL
    }
    public enum ResidenceFloor {
        HIGH, MEDIUM, LOW
    }

    @Data
    private static class StarRating implements Serializable {
        private Double traffic;
        private Double building;
        private Double inside;
        private Double infra;
        private Double security;
    }
}
