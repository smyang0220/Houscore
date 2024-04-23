package com.hs.houscore.controller;

import com.hs.houscore.jwt.service.JwtService;
import com.hs.houscore.postgre.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/token")
@Tag(name = "토큰 컨트롤러", description = "토큰 재발급 컨트롤러")
@CrossOrigin
public class TokenController {

    private final JwtService jwtService;

    private final MemberService memberService; // MemberService는 DB에서 사용자와 관련된 리프레시 토큰을 검증하는 로직을 포함
    @Autowired
    public TokenController(JwtService jwtService, MemberService memberService) {
        this.jwtService = jwtService;
        this.memberService = memberService;
    }

    @GetMapping("/refresh") // 401에러 발생시 클라이언트가 이 api 실행시켜야함
    @Operation(summary = "액세스 토큰 재발급", description = "리프레시 토큰이 만기되지 않았다면 액세스 토큰 재발급")
    public ResponseEntity<?> refreshAccessToken(HttpServletRequest request) {
        String refreshToken = request.getHeader("Authorization-refresh");
        if (refreshToken != null && jwtService.validateToken(refreshToken)) {
            String memberEmail = jwtService.getMemberEmailFromToken(refreshToken);
            // DB에 저장된 리프레시 토큰과 비교
            if (memberService.validateRefreshToken(memberEmail, refreshToken)) {
                // 새 액세스 토큰 생성
                String newAccessToken = jwtService.createAccessToken(memberEmail, memberService.getMemberNameByEmail(memberEmail), memberService.getProviderByEmail(memberEmail));
                // 새로 발급한 액세스 토큰을 바디로 반환
                HttpHeaders responseHeaders = new HttpHeaders();
                int maxAge = 60 * 60; // 1시간

                String cookieValue = String.format("access_token=%s; Max-Age=%d;", newAccessToken, maxAge);

                responseHeaders.add("Set-Cookie", cookieValue);

                return ResponseEntity.ok()
                        .headers(responseHeaders)
                        .body("Access token refreshed successfully");
            }
        }
        SecurityContextHolder.clearContext(); // 서버측 검증 정보 무효화
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid refresh token");
    }
}
