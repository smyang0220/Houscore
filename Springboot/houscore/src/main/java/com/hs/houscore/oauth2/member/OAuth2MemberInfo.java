package com.hs.houscore.oauth2.member;

import java.util.Map;

public interface OAuth2MemberInfo {

    OAuth2Provider getProvider();

    String getAccessToken();

    Map<String, Object> getAttributes();

    String getId();

    String getEmail();
    String getMemberName();

    String getProfileImageUrl();
}
