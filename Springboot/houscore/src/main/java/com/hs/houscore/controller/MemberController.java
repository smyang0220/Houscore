package com.hs.houscore.controller;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.postgre.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/member")
@Tag(name = "유저 컨트롤러", description = "사용자 관련 컨트롤러")
@CrossOrigin
public class MemberController {
    private final MemberService memberService;

    @Autowired
    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @GetMapping("/search") // 이메일 값은 엑세스 토큰 디코딩 하면 페이로드에 있음
    @Operation(summary = "사용자 검색", description = "이메일로 사용자 검색")
    public List<MemberDTO> searchMembers(
            @RequestParam @Parameter(description = "검색할 사용자 id") String memberEmail) {
        //return memberService.searchMembersByEmail(memberEmail);
        return null;
    }
}
