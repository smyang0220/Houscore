package com.hs.houscore.oauth2.service;

import com.hs.houscore.oauth2.exception.OAuth2AuthenticationProcessingException;
import com.hs.houscore.oauth2.member.OAuth2MemberInfo;
import com.hs.houscore.oauth2.member.OAuth2MemberInfoFactory;
import com.hs.houscore.postgre.entity.MemberEntity;
import com.hs.houscore.postgre.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@RequiredArgsConstructor
@Service
public class CustomOAuth2MemberService extends DefaultOAuth2UserService {

    private final MemberService memberService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest oAuth2UserRequest) throws OAuth2AuthenticationException {

        OAuth2User oAuth2User = super.loadUser(oAuth2UserRequest);

        try {
            return processOAuth2User(oAuth2UserRequest, oAuth2User);
        } catch (AuthenticationException ex) {
            throw ex;
        } catch (Exception ex) {
            // Throwing an instance of AuthenticationException will trigger the OAuth2AuthenticationFailureHandler
            throw new InternalAuthenticationServiceException(ex.getMessage(), ex.getCause());
        }
    }

    private OAuth2User processOAuth2User(OAuth2UserRequest userRequest, OAuth2User oAuth2User) {
        OAuth2MemberInfo oAuth2UserInfo = OAuth2MemberInfoFactory.getOAuth2MemberInfo(
                userRequest.getClientRegistration().getRegistrationId(),
                userRequest.getAccessToken().getTokenValue(),
                oAuth2User.getAttributes());

        if (!StringUtils.hasText(oAuth2UserInfo.getEmail())) {
            throw new OAuth2AuthenticationProcessingException("Email not found from OAuth2 provider");
        }

        MemberEntity member = memberService.createMember(oAuth2UserInfo, null);

        return new OAuth2MemberPrincipal(oAuth2UserInfo);
    }
}
