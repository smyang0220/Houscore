package com.hs.houscore.postgre.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Getter
@Setter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseTimeEntity {
    @Temporal(TemporalType.TIMESTAMP)
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt; // 생성 날짜

    @Temporal(TemporalType.TIMESTAMP)
    @LastModifiedDate
    private LocalDateTime updatedAt; // 업데이트 날짜

    // 엔티티가 영속성 컨텍스트에 저장되기 전에 호출됩니다.
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now(ZoneId.of("Asia/Seoul")); // 한국 시간대 설정
    }

    // 엔티티가 영속성 컨텍스트에 merge 될 때 호출됩니다.
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now(ZoneId.of("Asia/Seoul")); // 한국 시간대 설정
    }
}
