package com.hs.houscore.oauth2.member;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum OAuth2Provider {
    KAKAO("kakao");

    private final String registrationId;
}
