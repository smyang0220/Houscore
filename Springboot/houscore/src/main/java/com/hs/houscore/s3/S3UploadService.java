package com.hs.houscore.s3;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.hs.houscore.dto.FileUploadDTO;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
public class S3UploadService {

    private final AmazonS3Client amazonS3Client;

    @Value("${spring.cloud.aws.s3.bucket}")
    private String bucket;

    public String saveImage(FileUploadDTO fileUploadDTO) {
        String filenameWithPath = fileUploadDTO.getType() +"/"+ fileUploadDTO.getImageName();
        byte[] decodedImg = Base64.getDecoder().decode(fileUploadDTO.getImageBase64().split(",")[1]);
        ByteArrayInputStream inputStream = new ByteArrayInputStream(decodedImg);

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(decodedImg.length);
        String mimeType = fileUploadDTO.getImageBase64().split(";")[0].split(":")[1];
        metadata.setContentType(mimeType);

        amazonS3Client.putObject(bucket, filenameWithPath, inputStream, metadata);

        return amazonS3Client.getUrl(bucket, filenameWithPath).toString();
    }
}