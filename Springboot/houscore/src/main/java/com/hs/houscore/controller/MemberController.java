package com.hs.houscore.controller;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.jwt.service.JwtService;
import com.hs.houscore.oauth2.exception.OAuth2AuthenticationProcessingException;
import com.hs.houscore.oauth2.member.OAuth2MemberInfo;
import com.hs.houscore.postgre.entity.MemberEntity;
import com.hs.houscore.postgre.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/member")
@Tag(name = "유저 컨트롤러", description = "사용자 관련 컨트롤러")
@CrossOrigin
public class MemberController {
    private final JwtService jwtService;
    private final MemberService memberService;

    @Autowired
    public MemberController(JwtService jwtService, MemberService memberService) {
        this.jwtService = jwtService;
        this.memberService = memberService;
    }

    @GetMapping("/search") // 이메일 값은 엑세스 토큰 디코딩 하면 페이로드에 있음
    @Operation(summary = "사용자 검색", description = "이메일로 사용자 검색")
    public List<MemberDTO> searchMembers(
            @RequestParam @Parameter(description = "검색할 사용자 id") String memberEmail) {
        return memberService.searchMembersByEmail(memberEmail);
    }

    @PostMapping("/login/kakao")
    @Operation(summary = "카카오 토큰으로 로그인", description = "카카오 토큰을 검증하고 사용자 정보를 바탕으로 자체 토큰을 발급")
    public ResponseEntity<?> loginWithKakaoToken(@RequestBody Map<String, String> tokenData) {
        String kakaoAccessToken = tokenData.get("accessToken");
        String kakaoRefreshToken = tokenData.get("refreshToken");
        System.out.println(kakaoAccessToken);
        try {
            OAuth2MemberInfo kakaoMemberInfo = memberService.getMemberInfo("kakao", kakaoAccessToken, kakaoRefreshToken);
            // 여기에서는 사용자 이메일이 필요하므로 Email 검증을 추가
            if (!StringUtils.hasText(kakaoMemberInfo.getEmail())) {
                throw new OAuth2AuthenticationProcessingException("Email not found from Kakao data");
            }

            // 시스템에 사용자를 등록하거나 업데이트하고, 토큰을 발급
            MemberEntity member = memberService.createMember(kakaoMemberInfo, kakaoRefreshToken);
            String accessToken = jwtService.createAccessToken(member.getMemberEmail(), member.getMemberName(), member.getProvider().toString());
            String refreshToken = jwtService.createRefreshToken(member.getMemberEmail(), member.getMemberName(), member.getProvider().toString());

            // JSON 형태로 토큰을 반환
            Map<String, String> tokens = new HashMap<>();
            tokens.put("accessToken", accessToken);
            tokens.put("refreshToken", refreshToken);

            System.out.println("됐는데?");
            return ResponseEntity.ok(tokens);
        } catch (AuthenticationException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Authentication failed with Kakao token: " + ex.getMessage());
        }
    }


    @PostMapping("/refresh")
    @Operation(summary = "액세스 토큰 재발급", description = "리프레시 토큰으로 액세스 토큰 재발급")
    public ResponseEntity<?> refreshAccessToken(HttpServletRequest request) {
        String refreshToken = request.getHeader("refreshToken").substring(7);
        if (jwtService.validateToken(refreshToken)) {
            String memberEmail = jwtService.getMemberEmailFromToken(refreshToken);
            if (memberService.validateRefreshToken(memberEmail, refreshToken)) {
                String newAccessToken = jwtService.createAccessToken(memberEmail, memberService.getMemberNameByEmail(memberEmail), memberService.getProviderByEmail(memberEmail));

                // JSON 형태로 토큰을 반환
                Map<String, String> tokens = new HashMap<>();
                tokens.put("accessToken", newAccessToken);
                return ResponseEntity.ok(tokens);
            }
        }
        SecurityContextHolder.clearContext();
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid refresh token");
    }
}
