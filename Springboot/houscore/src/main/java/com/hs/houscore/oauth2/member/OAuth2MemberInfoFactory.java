package com.hs.houscore.oauth2.member;

import com.hs.houscore.oauth2.exception.OAuth2AuthenticationProcessingException;
import java.util.Map;

public class OAuth2MemberInfoFactory {
    public static OAuth2MemberInfo getOAuth2MemberInfo(String registrationId,
                                                     String accessToken,
                                                     Map<String, Object> attributes) {
       if (OAuth2Provider.KAKAO.getRegistrationId().equals(registrationId)) {
            return new KakaoOAuth2MemberInfo(accessToken, attributes);
        } else {
            throw new OAuth2AuthenticationProcessingException("Login with " + registrationId + " is not supported");
        }
    }
}
