package com.hs.houscore.s3;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.hs.houscore.dto.FileUploadDTO;
import java.io.ByteArrayInputStream;
import java.util.Base64;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class S3UploadService {

    private final AmazonS3Client amazonS3Client;

    @Value("${spring.cloud.aws.s3.bucket}")
    private String bucket;

    public String saveImage(FileUploadDTO fileUploadDTO) {
        String filenameWithPath = "houscore/" + fileUploadDTO.getImageName();
        byte[] decodedImg = Base64.getDecoder().decode(fileUploadDTO.getImageBase64());
        ByteArrayInputStream inputStream = new ByteArrayInputStream(decodedImg);

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(decodedImg.length);
        metadata.setContentType("image/jpeg");

        amazonS3Client.putObject(bucket, filenameWithPath, inputStream, metadata);

        return amazonS3Client.getUrl(bucket, filenameWithPath).toString();
    }

    public String deleteImage(String imgUrl) {
        String result = "Delete success.";

        try {
            // URL에서 마지막 부분을 추출하여 keyName을 생성
            String[] parts = imgUrl.split("/");
            String keyName = "houscore/" + parts[parts.length - 1];

            // S3 버킷에서 해당 객체 존재 여부 확인
            boolean isObjectExist = amazonS3Client.doesObjectExist(bucket, keyName);
            if (isObjectExist) {
                amazonS3Client.deleteObject(bucket, keyName);
            } else {
                result = "file not found";
            }
        } catch (Exception e) {
            log.debug("Delete File failed", e);
            result = "Error in deleting file";
        }

        return result;
    }
}