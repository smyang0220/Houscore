package com.hs.houscore.postgre.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Data
@Table(name = "my_interested_area")
@SequenceGenerator(name="my_interested_area_seq", sequenceName="my_interested_area_seq", initialValue=1, allocationSize=1)
public class MyInterestedAreaEntity extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long areaId;
    private String memberId;
    private String address;
}
