package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "real_transaction_price")
@Data
@AllArgsConstructor
public class RealTransactionPriceEntity {
    //공공데이터 - 실거래가
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String platPlc;
    private String bldNm;
    private Date contractDate;
    private Double area;
    private Integer floor;
    private String houseType;
    private String tradeType;
    private String tradeAmount;
}
