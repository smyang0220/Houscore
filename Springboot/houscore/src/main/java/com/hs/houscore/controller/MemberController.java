package com.hs.houscore.controller;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.jwt.service.JwtService;
import com.hs.houscore.postgre.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
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

    @PostMapping("/login")
    @Operation(summary = "사용자 로그인", description = "사용자 이메일로 로그인하고 토큰을 발급")
    public ResponseEntity<?> login(@RequestBody MemberDTO loginData) {
        if (memberService.validateMember(loginData.getMemberEmail())) {
            String memberEmail = loginData.getMemberEmail();
            String accessToken = jwtService.createAccessToken(memberEmail, memberService.getMemberNameByEmail(memberEmail), memberService.getProviderByEmail(memberEmail));
            String refreshToken = jwtService.createRefreshToken(memberEmail, memberService.getProviderByEmail(memberEmail));

            HttpHeaders headers = new HttpHeaders();
            headers.add("Access-Token", accessToken);
            headers.add("Refresh-Token", refreshToken);

            return ResponseEntity.ok().headers(headers).body("Login successful");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Authentication failed");
    }

    @GetMapping("/refresh")
    @Operation(summary = "액세스 토큰 재발급", description = "리프레시 토큰으로 액세스 토큰 재발급")
    public ResponseEntity<?> refreshAccessToken(HttpServletRequest request) {
        String refreshToken = request.getHeader("Authorization-refresh");
        if (refreshToken != null && jwtService.validateToken(refreshToken)) {
            String memberEmail = jwtService.getMemberEmailFromToken(refreshToken);
            if (memberService.validateRefreshToken(memberEmail, refreshToken)) {
                String newAccessToken = jwtService.createAccessToken(memberEmail, memberService.getMemberNameByEmail(memberEmail), memberService.getProviderByEmail(memberEmail));
                HttpHeaders responseHeaders = new HttpHeaders();
                responseHeaders.add("Set-Cookie", "access_token=" + newAccessToken + "; Max-Age=3600; HttpOnly");
                return ResponseEntity.ok().headers(responseHeaders).body("Access token refreshed successfully");
            }
        }
        SecurityContextHolder.clearContext();
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid refresh token");
    }
}
