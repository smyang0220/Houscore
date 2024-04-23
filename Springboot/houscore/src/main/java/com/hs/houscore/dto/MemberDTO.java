package com.hs.houscore.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberDTO {
    private String memberEmail;
    private String memberName;
    private String profileImage;

    public MemberDTO(String memberEmail, String memberName, String profileImage) {
        this.memberEmail = memberEmail;
        this.memberName = memberName;
        this.profileImage = profileImage;
    }
}