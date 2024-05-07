package com.hs.houscore.mongo;

import com.hs.houscore.mongo.entity.BuildingEntity;
import com.hs.houscore.mongo.service.SequenceGeneratorService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.mapping.event.AbstractMongoEventListener;
import org.springframework.data.mongodb.core.mapping.event.BeforeConvertEvent;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class BuildingListener extends AbstractMongoEventListener<BuildingEntity> {
    private final SequenceGeneratorService generatorService;

    @Override
    public void onBeforeConvert(BeforeConvertEvent<BuildingEntity> event) {
        event.getSource().setId(generatorService.generateSequence(BuildingEntity.SEQUENCE_NAME));
    }
}
