package com.hs.houscore.oauth2.member;

import com.hs.houscore.postgre.entity.MemberEntity;

import java.util.Map;

public interface OAuth2MemberInfo {

    OAuth2Provider getProvider();

    String getRefreshToken();

    Map<String, Object> getAttributes();

    String getId();
    String getEmail();
    String getMemberName();
    MemberEntity.Role getRole();
    String getProfileImageUrl();
}
