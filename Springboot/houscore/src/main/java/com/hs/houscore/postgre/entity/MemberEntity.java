package com.hs.houscore.postgre.entity;

import com.hs.houscore.oauth2.member.OAuth2Provider;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "members")
@Data
@AllArgsConstructor
public class MemberEntity {
    @Id
    private String memberEmail;
    private String memberName;
    private String password;
    private String profileImage;
    @Enumerated(EnumType.STRING)
    private OAuth2Provider provider;
    private String refreshToken;

    public void passwordEncode(PasswordEncoder passwordEncoder) {
        this.password = passwordEncoder.encode(this.password);
    }

    public void updateRefreshToken(String updateRefreshToken) {
        this.refreshToken = updateRefreshToken;
    }
}
