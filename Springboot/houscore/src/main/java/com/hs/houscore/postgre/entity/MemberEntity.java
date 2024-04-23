package com.hs.houscore.postgre.entity;

import com.hs.houscore.oauth2.member.OAuth2Provider;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Date;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Builder
@Table(name = "members")
@Data
@AllArgsConstructor
public class MemberEntity {
    @Id
    private String memberEmail;
    private String name;
    private String memberName;
    private String password;
    private String profileImage;
    private String age_range;
    private String social;

    @Enumerated(EnumType.STRING)
    private Gender gender; // 성별 enum 타입

    @Enumerated(EnumType.STRING)
    private Role role; // 역할 enum 타입

    @Enumerated(EnumType.STRING)
    private OAuth2Provider provider;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt; // 생성 날짜

    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt; // 업데이트 날짜

    private String refreshToken;

    public void passwordEncode(PasswordEncoder passwordEncoder) {
        this.password = passwordEncoder.encode(this.password);
    }

    public void updateRefreshToken(String updateRefreshToken) {
        this.refreshToken = updateRefreshToken;
    }

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

    // 성별을 위한 Enum 타입
    public enum Gender {
        MAN, WOMAN
    }

    // 역할을 위한 Enum 타입
    public enum Role {
        MEMBER, ADMIN
    }
}
