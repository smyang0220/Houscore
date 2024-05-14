package com.hs.houscore.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MyInfoDTO {
    private Long areaId;
    private String address;
}
