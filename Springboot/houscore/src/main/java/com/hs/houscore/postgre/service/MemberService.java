package com.hs.houscore.postgre.service;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.oauth2.exception.OAuth2AuthenticationProcessingException;
import com.hs.houscore.oauth2.member.KakaoOAuth2MemberInfo;
import com.hs.houscore.postgre.entity.MemberEntity;
import com.hs.houscore.postgre.repository.MemberRepository;
import com.hs.houscore.oauth2.member.OAuth2MemberInfo;
import jakarta.transaction.Transactional;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@Transactional
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final RestTemplate restTemplate;

    public MemberEntity createMember(OAuth2MemberInfo memberInfo) {
        // First, check if member already exists
        Optional<MemberEntity> existingMember = memberRepository.findByMemberEmail(memberInfo.getEmail());
        if (existingMember.isPresent()) {
            // If member exists, update existing member
            return updateMember(existingMember.get(), memberInfo);
        } else {
            // If not, create a new member
            MemberEntity newMember = MemberEntity.builder()
                    .memberEmail(memberInfo.getEmail())
                    .memberName(memberInfo.getMemberName())
                    .profileImage(memberInfo.getProfileImageUrl())
                    .role(memberInfo.getRole())
                    .provider(memberInfo.getProvider())
                    .refreshToken(memberInfo.getRefreshToken())
                    .build();
            return memberRepository.save(newMember);
        }
    }

    public MemberEntity updateMember(MemberEntity member, OAuth2MemberInfo memberInfo) {
        member.setMemberName(memberInfo.getMemberName());
        member.setProfileImage(memberInfo.getProfileImageUrl());
        member.setRole(memberInfo.getRole());
        member.setProvider(memberInfo.getProvider());
        member.setRefreshToken(memberInfo.getRefreshToken());
        return memberRepository.save(member);
    }

    public String getMemberNameByEmail(String memberEmail) {
        Optional<MemberEntity> member = memberRepository.findByMemberEmail(memberEmail);
        return member.map(MemberEntity::getMemberName).orElse(null); // 사용자가 존재하지 않는 경우 null 반환
    }

    public OAuth2MemberInfo getMemberInfo(String provider, String accessToken) throws OAuth2AuthenticationException {
        if (!provider.equals("kakao")) {
            throw new OAuth2AuthenticationException("Unsupported provider: " + provider);
        }
        return fetchKakaoUserInfo(accessToken);
    }

    private OAuth2MemberInfo fetchKakaoUserInfo(String accessToken) {
        String url = "https://kapi.kakao.com/v2/user/me";
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<Map<String, Object>> response = restTemplate.exchange(url, HttpMethod.GET, entity, new ParameterizedTypeReference<Map<String, Object>>() {});
        if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
            return parseKakaoUserInfo(accessToken, response.getBody());
        } else {
            throw new OAuth2AuthenticationException("Failed to fetch user info from Kakao");
        }
    }

    private OAuth2MemberInfo parseKakaoUserInfo(String accessToken, Map<String, Object> kakaoData) {
        Map<String, Object> kakaoAccount = (Map<String, Object>) Optional.ofNullable(kakaoData.get("kakao_account"))
                .orElseThrow(() -> new OAuth2AuthenticationException("Missing account details"));
        return new KakaoOAuth2MemberInfo(accessToken, kakaoData);
    }

    // 사용자의 이메일로 공급자 정보를 조회하는 메서드
    public String getProviderByEmail(String memberEmail) {
        Optional<MemberEntity> member = memberRepository.findByMemberEmail(memberEmail);
        return member.map(u -> u.getProvider().toString()).orElse(null); // 사용자가 존재하지 않는 경우 null 반환
    }

    // 리프레시 토큰을 저장하는 메서드
    public void updateRefreshToken(String memberEmail, String refreshToken) {
        MemberEntity member = memberRepository.findByMemberEmail(memberEmail)
                .orElseThrow(() -> new IllegalArgumentException("Cannot find member with email: " + memberEmail));
        member.updateRefreshToken(refreshToken);
        memberRepository.save(member);
    }

    @Transactional
    public void deleteMemberAndRefreshToken(String memberEmail) {
        MemberEntity member = memberRepository.findByMemberEmail(memberEmail)
                .orElseThrow(() -> new IllegalArgumentException("Cannot find member with email: " + memberEmail));
        memberRepository.delete(member); // 사용자 정보 삭제

        // 리프레시 토큰을 관리하는 로직이 있다면 여기에서 리프레시 토큰 삭제 처리
    }

    public boolean validateRefreshToken(String memberEmail, String refreshToken) {
        Optional<MemberEntity> memberOptional = memberRepository.findByMemberEmail(memberEmail);
        if (memberOptional.isPresent()) {
            MemberEntity member = memberOptional.get();
            return refreshToken.equals(member.getRefreshToken());
        }
        return false;
    }

    // 검색을 통해 이메일 리스트를 반환
    public List<MemberDTO> searchMembersByEmail(String email) {
        return memberRepository.findByEmailContaining(email);
    }

    public MemberEntity getMemberByRefreshToken(String refreshToken) {
        Optional<MemberEntity> memberOptional = memberRepository.findByRefreshToken(refreshToken);
        return memberOptional.orElse(null);
    }

    // 유저 존재 검증
    public boolean validateMember(String memberEmail) {
        Optional<MemberEntity> member = memberRepository.findByMemberEmail(memberEmail);
        return member.isPresent();
    }
}