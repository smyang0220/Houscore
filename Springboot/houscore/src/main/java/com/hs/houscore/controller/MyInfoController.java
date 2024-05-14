package com.hs.houscore.controller;

import com.hs.houscore.dto.MemberDTO;
import com.hs.houscore.dto.MyInfoDTO;
import com.hs.houscore.dto.RequestMyInfoDTO;
import com.hs.houscore.oauth2.member.OAuth2MemberInfo;
import com.hs.houscore.oauth2.service.OAuth2MemberPrincipal;
import com.hs.houscore.postgre.entity.MemberEntity;
import com.hs.houscore.postgre.entity.MyInterestedAreaEntity;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.service.MemberService;
import com.hs.houscore.postgre.service.MyInterestedAreaService;
import com.hs.houscore.response.ErrorResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/myinfo")
@Tag(name = "내정보 컨트롤러", description = "사용자 정보 관련 컨트롤러")
@CrossOrigin
public class MyInfoController {
    private final MyInterestedAreaService myInterestedAreaService;
    private final MemberService memberService;

    @Autowired
    public MyInfoController(MyInterestedAreaService myInterestedAreaService, MemberService memberService) {
        this.myInterestedAreaService = myInterestedAreaService;
        this.memberService = memberService;
    }

    @GetMapping("")
    @Operation(summary = "사용자 검색", description = "이메일로 사용자 검색")
    public MemberEntity getMyInfo(@RequestParam String refreshToken) {
        return memberService.getMemberByRefreshToken(refreshToken);
    }

    @GetMapping("/area")
    @Operation(summary = "관심 지역 리스트", description = "관심 지역 리스트 조회")
    public ResponseEntity<?> getMyInterestedArea(@AuthenticationPrincipal String memberEmail) {
        try {
            //유저 검증
            if(memberEmail == null || memberEmail.equals("anonymousUser")){
                return ResponseEntity.badRequest().body(new ErrorResponse("사용자 검증 필요"));
            }

            List<MyInfoDTO> myInterestedAreaEntities = myInterestedAreaService.getMyInterestedAreaList(memberEmail);
            if(myInterestedAreaEntities == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMyInterestedAreaList NullException"));
            }else if (myInterestedAreaEntities.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMyInterestedAreaList is Empty"));
            }
            return ResponseEntity.ok(myInterestedAreaEntities);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("BuildingController getMyInterestedAreaList failure"));
        }
    }

    @PostMapping("/area")
    @Operation(summary = "관심 지역 등록", description = "관심 지역 등록")
    public ResponseEntity<?> setMyInterestedArea(@AuthenticationPrincipal String memberEmail,
                                                 @RequestParam RequestMyInfoDTO requestMyInfoDTO) {
        try{
            //유저 검증
            if(memberEmail == null || memberEmail.equals("anonymousUser")){
                return ResponseEntity.badRequest().body(new ErrorResponse("사용자 검증 필요"));
            }

            myInterestedAreaService.setMyInterestedArea(requestMyInfoDTO.getAddress());
            return ResponseEntity.status(HttpStatus.CREATED).body("관심지역 등록 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 관심지역 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("관심지역 등록 실패!");
        }
    }

    @DeleteMapping("/area")
    @Operation(summary = "관심 지역 삭제", description = "관심 지역 삭제")
    public ResponseEntity<?> delMyInterestedArea(@RequestParam Long areaId,
                                                 @AuthenticationPrincipal String memberEmail) {
        try {
            //유저 검증
            if(memberEmail == null || memberEmail.equals("anonymousUser")){
                return ResponseEntity.badRequest().body(new ErrorResponse("사용자 검증 필요"));
            }

            myInterestedAreaService.deleteMyInterestedArea(areaId, memberEmail);
            return ResponseEntity.status(HttpStatus.OK).body("관심 지역 삭제 성공");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("유효하지 않은 관심지역 데이터");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("관심지역 삭제 실패!");
        }
    }

}
