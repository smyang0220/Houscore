package com.hs.houscore.postgre.entity;

import jakarta.persistence.*;
import lombok.Getter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.util.Date;

@Getter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseTimeEntity {
    @Temporal(TemporalType.TIMESTAMP)
    @CreatedDate
    @Column(updatable = false)
    private Date createdAt; // 생성 날짜

    @Temporal(TemporalType.TIMESTAMP)
    @LastModifiedDate
    private Date updatedAt; // 업데이트 날짜

    // 엔티티가 영속성 컨텍스트에 저장되기 전에 호출됩니다.
    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
    }

    // 엔티티가 영속성 컨텍스트에 merge 될 때 호출됩니다.
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = new Date();
    }
}
