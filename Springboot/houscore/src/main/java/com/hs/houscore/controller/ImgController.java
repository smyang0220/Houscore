package com.hs.houscore.controller;

import com.hs.houscore.dto.FileUploadDTO;
import com.hs.houscore.s3.S3UploadService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/image")
@RequiredArgsConstructor
@CrossOrigin
@Slf4j
@Tag(name = "이미지 컨트롤러", description = "S3 이미지 저장 컨트롤러")
public class ImgController {

    private final S3UploadService s3UploadService;

    @PostMapping("/project")
    @Operation(summary = "리뷰 내 이미지 추가", description = "리뷰 내 삽입된 이미지 저장 후, 이미지 url 반환")
    public ResponseEntity<String> updateProfileImage(
            @RequestParam @Parameter(description = "imageBase64 : 인코딩된 이미지 ")FileUploadDTO fileUploadDTO) {
        String result = s3UploadService.saveImage(fileUploadDTO);
        return ResponseEntity.ok(result);
    }
}
