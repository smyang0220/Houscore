package com.hs.houscore.oauth2.member;

import com.hs.houscore.oauth2.exception.OAuth2AuthenticationProcessingException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class OAuth2MemberUnlinkManager {

    private final KakaoOAuth2MemberUnlink kakaoOAuth2MemberUnlink;

    public void unlink(OAuth2Provider provider, String accessToken) {
        if (OAuth2Provider.KAKAO.equals(provider)) {
            kakaoOAuth2MemberUnlink.unlink(accessToken);
        } else {
            throw new OAuth2AuthenticationProcessingException(
                    "Unlink with " + provider.getRegistrationId() + " is not supported");
        }
    }
}
