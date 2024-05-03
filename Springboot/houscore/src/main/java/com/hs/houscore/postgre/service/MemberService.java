package com.hs.houscore.postgre.service;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.postgre.entity.MemberEntity;
import com.hs.houscore.postgre.repository.MemberRepository;
import com.hs.houscore.oauth2.member.OAuth2MemberInfo;
import jakarta.transaction.Transactional;

import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@Transactional
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    public MemberEntity createMember(OAuth2MemberInfo memberInfo) {
        MemberEntity member = memberRepository.findByMemberEmail(memberInfo.getEmail())
                .orElse(MemberEntity.builder()
                        .memberEmail(memberInfo.getEmail())
                        .memberName(memberInfo.getMemberName())
                        .profileImage(memberInfo.getProfileImageUrl())
                        .role(memberInfo.getRole())
                        .provider(memberInfo.getProvider())
                        .refreshToken(memberInfo.getAccessToken())
                        .build());

        return memberRepository.save(member);
    }

    public String getMemberNameByEmail(String memberEmail) {
        Optional<MemberEntity> member = memberRepository.findByMemberEmail(memberEmail);
        return member.map(MemberEntity::getMemberName).orElse(null); // 사용자가 존재하지 않는 경우 null 반환
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
