package com.hs.houscore.oauth2.member;

import com.hs.houscore.postgre.entity.MemberEntity;

import java.util.Map;

public class KakaoOAuth2MemberInfo implements OAuth2MemberInfo {

    private final Map<String, Object> attributes;
    private final String accessToken;
    private final String id;
    private final MemberEntity.Role role;
    private final String email;
    private final String memberName;
    private final String profileImageUrl;

    public KakaoOAuth2MemberInfo(String accessToken, Map<String, Object> attributes) {
        this.accessToken = accessToken;
        // attributes 맵의 kakao_account 키의 값에 실제 attributes 맵이 할당되어 있음
        Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
        Map<String, Object> kakaoProfile = (Map<String, Object>) kakaoAccount.get("profile");
        this.attributes = kakaoProfile;

        this.id = ((Long) attributes.get("id")).toString();
        this.email = (String) kakaoAccount.get("email");
        this.role = MemberEntity.Role.MEMBER;
        this.memberName = (String) kakaoProfile.get("nickname");

        this.profileImageUrl = (String) kakaoProfile.get("profile_image_url");

        this.attributes.put("id", id);
        this.attributes.put("email", this.email);
    }

    @Override
    public OAuth2Provider getProvider() {
        return OAuth2Provider.KAKAO;
    }

    @Override
    public String getAccessToken() {
        return accessToken;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public String getEmail() {
        return email;
    }

    @Override
    public String getMemberName() {
        return memberName;
    }

    @Override
    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    @Override
    public MemberEntity.Role getRole() {
        return role;
    }
}
