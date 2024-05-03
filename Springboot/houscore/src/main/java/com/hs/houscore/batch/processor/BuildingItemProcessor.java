package com.hs.houscore.batch.processor;

import com.hs.houscore.batch.entity.MasterRegisterEntity;
import com.hs.houscore.batch.repository.MasterRegisterRepository;
import com.hs.houscore.mongo.entity.BuildingEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.beans.factory.annotation.Autowired;

@Slf4j
public class BuildingItemProcessor implements ItemProcessor<BuildingEntity, BuildingEntity> {

    @Autowired
    private MasterRegisterRepository masterRegisterRepository;

    public BuildingItemProcessor(MasterRegisterRepository masterRegisterRepository) {
        this.masterRegisterRepository = masterRegisterRepository;
    }

    @Override
    public BuildingEntity process(BuildingEntity building) throws Exception {
        //배치를 처리할 로직이 들어가는 부분
        //표제부 데이터
        MasterRegisterEntity masterRegisterEntity = masterRegisterRepository.findByNewPlatPlcOrPlatPlc(building.getNewPlatPlc(), building.getPlatPlc())
                .orElse(null);
        if(masterRegisterEntity != null) {
            BuildingEntity.Information information = new BuildingEntity.Information();
            information.setBuildingInfo(BuildingEntity.BuildingInfo.builder()
                            .archArea(masterRegisterEntity.getArchArea())
                            .build());
            building.setInformation(information);
        }
        building.setBatchYn("y");
        return building;
    }
}
