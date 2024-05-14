package com.hs.houscore.batch.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "individual_publicly_announced_price")
@Data
@AllArgsConstructor
public class IndividualPubliclyAnnouncedPriceEntity {
    //공공데이터 - 공시지가
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String pnuCode;
    private String platPlac;
    private Long officialPrice;
    private Date announcedDate;
    private Date baseData;
}
