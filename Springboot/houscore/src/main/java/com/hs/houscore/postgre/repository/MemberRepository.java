package com.hs.houscore.postgre.repository;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.postgre.entity.MemberEntity;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberRepository extends JpaRepository<MemberEntity, Long> {
    Optional<MemberEntity> findByMemberEmail(String memberEmail);
    Optional<MemberEntity> findByMemberName(String memberName);
    Optional<MemberEntity> findByRefreshToken(String refreshToken);

    // 이메일에 특정 문자열이 포함된 사용자를 검색하는 쿼리
    @Query("SELECT new com.hs.houscore.dto.MemberDTO(u.memberEmail, u.memberName, u.profileImage) FROM MemberEntity u WHERE u.memberEmail LIKE %?1%")
    List<MemberDTO> findByEmailContaining(String email);
    @Modifying
    @Query("UPDATE MemberEntity u SET u.profileImage = :imageUrl WHERE u.memberEmail = :memberEmail")
    int updateProfileImage(String memberEmail, String imageUrl);
}
