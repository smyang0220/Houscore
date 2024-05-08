package com.hs.houscore.oauth2.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Component
public class OAuth2AuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    private final JwtService jwtService;
    private final MemberService memberService;

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

        // 바디에 토큰 추가 (JSON 형태로 반환)
        Map<String, String> tokens = new HashMap<>();
        tokens.put("accessToken", accessToken);
        tokens.put("refreshToken", refreshToken);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(new ObjectMapper().writeValueAsString(tokens));
        out.flush();

        clearAuthenticationAttributes(request);
        response.setStatus(HttpServletResponse.SC_OK);
    }
    private OAuth2MemberPrincipal getOAuth2MemberPrincipal(Authentication authentication) {
        return (authentication.getPrincipal() instanceof OAuth2MemberPrincipal) ? (OAuth2MemberPrincipal) authentication.getPrincipal() : null;
    }
}