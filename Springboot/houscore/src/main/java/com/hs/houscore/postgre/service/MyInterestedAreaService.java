package com.hs.houscore.postgre.service;

import com.hs.houscore.postgre.entity.MyInterestedAreaEntity;
import com.hs.houscore.postgre.repository.MyInterestedAreaRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class MyInterestedAreaService {
    private final MyInterestedAreaRepository myInterestedAreaRepository;

    public List<MyInterestedAreaEntity> getMyInterestedAreaList(String memberId){
        return myInterestedAreaRepository.findByMemberId(memberId);
    }

    public void setMyInterestedArea(MyInterestedAreaEntity myInterestedArea){
        myInterestedAreaRepository.save(myInterestedArea);
    }

    public void deleteMyInterestedArea(Long areaId, String memberId){
        myInterestedAreaRepository.findByMemberIdAndAreaId(memberId, areaId)
                .map(myInterestedAreaEntity -> {
                    myInterestedAreaRepository.delete(myInterestedAreaEntity);
                    return myInterestedAreaEntity;
                })
                .orElseThrow(() -> new IllegalArgumentException("해당 데이터가 존재 하지 않습니다."));
    }
}
