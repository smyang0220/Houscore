package com.hs.houscore.oauth2.member;

import com.hs.houscore.oauth2.exception.OAuth2AuthenticationProcessingException;
import java.util.Map;

public class OAuth2MemberInfoFactory {
    public static OAuth2MemberInfo getOAuth2MemberInfo(String registrationId,
                                                     String accessToken,
                                                     Map<String, Object> attributes) {
        return switch (registrationId) {
            case "kakao" -> new KakaoOAuth2MemberInfo(accessToken, attributes);
            case "google" -> null;
            default ->
                    throw new OAuth2AuthenticationProcessingException("Login with " + registrationId + " is not supported");
        };
    }
}
