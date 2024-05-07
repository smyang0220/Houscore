package com.hs.houscore.oauth2.handler;

import com.hs.houscore.jwt.service.JwtService;
import com.hs.houscore.postgre.entity.MemberEntity;
import com.hs.houscore.postgre.service.MemberService;
import com.hs.houscore.oauth2.service.OAuth2MemberPrincipal;
import com.hs.houscore.oauth2.member.OAuth2MemberUnlinkManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.http.HttpHeaders;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@Component
public class OAuth2AuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final JwtService jwtService;
    private final MemberService memberService;
    private final OAuth2MemberUnlinkManager oAuth2MemberUnlinkManager;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {

        OAuth2MemberPrincipal principal = getOAuth2MemberPrincipal(authentication);

        if (principal == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication Failed");
            return;
        }

        // 액세스 토큰, 리프레시 토큰 발급
        MemberEntity member = memberService.createMember(principal.getUserInfo());
        String accessToken = jwtService.createAccessToken(member.getMemberEmail(), member.getMemberName(), member.getProvider().toString());
        String refreshToken = jwtService.createRefreshToken(member.getMemberEmail(), member.getProvider().toString());

        // 헤더에 토큰 추가
        response.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken);
        response.setHeader("Refresh-Token", refreshToken);

        // 리프레시 토큰 DB 저장
        memberService.updateRefreshToken(member.getMemberEmail(), refreshToken);

        clearAuthenticationAttributes(request);
        String targetUrl = determineTargetUrl(request, response, principal);
        getRedirectStrategy().sendRedirect(request, response, targetUrl);
    }

    private OAuth2MemberPrincipal getOAuth2MemberPrincipal(Authentication authentication) {
        return (authentication.getPrincipal() instanceof OAuth2MemberPrincipal) ? (OAuth2MemberPrincipal) authentication.getPrincipal() : null;
    }

    protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response, OAuth2MemberPrincipal principal) {
        String targetUrl = getDefaultTargetUrl();
        return targetUrl; // 클라이언트가 정상적으로 리디렉트될 URL을 구성
    }
}