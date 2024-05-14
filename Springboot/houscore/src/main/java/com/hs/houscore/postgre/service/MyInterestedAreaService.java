package com.hs.houscore.postgre.service;

import com.hs.houscore.dto.MyInfoDTO;
import com.hs.houscore.postgre.entity.MyInterestedAreaEntity;
import com.hs.houscore.postgre.entity.ReviewEntity;
import com.hs.houscore.postgre.repository.MyInterestedAreaRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class MyInterestedAreaService {
    private final MyInterestedAreaRepository myInterestedAreaRepository;

    public List<MyInfoDTO> getMyInterestedAreaList(String memberEmail){
        List<MyInterestedAreaEntity> myInterestedAreaEntities = myInterestedAreaRepository.findByMemberEmail(memberEmail);
        List<MyInfoDTO> myInfoDTOS = new ArrayList<>();
        for(MyInterestedAreaEntity myInterestedAreaEntity : myInterestedAreaEntities){
            myInfoDTOS.add(MyInfoDTO.builder()
                            .areaId(myInterestedAreaEntity.getAreaId())
                            .address(myInterestedAreaEntity.getAddress())
                    .build());
        }
        return myInfoDTOS;
    }

    public void setMyInterestedArea(String address, String memberEmail){
        myInterestedAreaRepository.save(MyInterestedAreaEntity.builder().address(address).memberEmail(memberEmail).build());
    }

    public void deleteMyInterestedArea(Long areaId, String memberEmail){
        myInterestedAreaRepository.findByMemberEmailAndAreaId(memberEmail, areaId)
                .map(myInterestedAreaEntity -> {
                    myInterestedAreaRepository.delete(myInterestedAreaEntity);
                    return myInterestedAreaEntity;
                })
                .orElseThrow(() -> new IllegalArgumentException("해당 데이터가 존재 하지 않습니다."));
    }
}
