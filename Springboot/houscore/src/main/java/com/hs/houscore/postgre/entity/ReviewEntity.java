package com.hs.houscore.postgre.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.io.Serializable;

@EqualsAndHashCode(callSuper = true)
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Data
@Builder
@Table(name = "review")
@SequenceGenerator(name="review_seq", sequenceName="review_seq", initialValue=1, allocationSize=1)
public class ReviewEntity extends BaseTimeEntity{
    @Id
    @GeneratedValue (strategy = GenerationType.SEQUENCE)
    private Long id;
    private String memberId;
    private String address;
    private ResidenceType residenceType;
    private String year;
    private ResidenceFloor residenceFloor;
    @JdbcTypeCode(SqlTypes.JSON)
    private StarRating starRating;
    private String pros;
    private String cons;
    private String maintenanceCost;
    private String images;

    public enum ResidenceType {
        VILLA, APT, OFFICETEL;

        public static ResidenceType fromString(String residenceType) {
            if (residenceType.equalsIgnoreCase("원룸/빌라")) {
                return VILLA;
            } else if (residenceType.equalsIgnoreCase("아파트")) {
                return APT;
            } else if (residenceType.equalsIgnoreCase("오피스텔")) {
                return OFFICETEL;
            } else {
                // 기본값으로 예외처리하거나 다른 로직을 추가할 수 있습니다.
                throw new IllegalArgumentException("Invalid ResidenceType: " + residenceType);
            }
        }
    }
    public enum ResidenceFloor {
        HIGH, MEDIUM, LOW, BOTTOM;

        public static ResidenceFloor fromFloorNumber(String floorNumber) {
            if (floorNumber == "1층") {
                return BOTTOM;
            } else if (floorNumber == "2~5층") {
                return LOW;
            } else if (floorNumber == "5~15층") {
                return MEDIUM;
            } else {
                return HIGH;
            }
        }
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class StarRating implements Serializable {
        private Double traffic;
        private Double building;
        private Double inside;
        private Double infra;
        private Double security;

        public double average() {
            return (traffic + building + inside + infra + security) / 5.0;
        }
    }

    // 다른 서비스에서 접근할 평균 반환
    public double getStarRatingAverage() {
        return this.starRating.average();
    }
}
