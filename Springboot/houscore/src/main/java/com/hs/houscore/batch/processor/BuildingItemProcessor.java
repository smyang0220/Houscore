package com.hs.houscore.batch.processor;

import com.hs.houscore.batch.entity.MasterRegisterEntity;
import com.hs.houscore.batch.entity.RealTransactionPriceEntity;
import com.hs.houscore.batch.repository.MasterRegisterRepository;
import com.hs.houscore.batch.repository.RealTransactionPriceRepository;
import com.hs.houscore.mongo.entity.BuildingEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.item.ItemProcessor;

import java.util.HashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
public class BuildingItemProcessor implements ItemProcessor<BuildingEntity, BuildingEntity> {

    private final MasterRegisterRepository masterRegisterRepository;
    private final RealTransactionPriceRepository realTransactionPriceRepository;

    @Override
    public BuildingEntity process(BuildingEntity building) throws Exception {
        //배치를 처리할 로직이 들어가는 부분

        return BuildingEntity.builder()
                .id(building.getId())
                .score(building.getScore())
                .location(building.getLocation())
                .platPlc(building.getPlatPlc())
                .newPlatPlc(building.getNewPlatPlc())
                .sigunguCd("")
                .bjdongCd("")
                .bldNm("")
                .pnuCode("")
                .batchYn("y")
                .information(BuildingEntity.Information.builder()
                        .buildingInfo(setBuildingInfo(building))
                        .priceInfo(setPriceInfo(building))
                        .infraInfo(setInfraInfo(building))
                        .securityInfo(setSecurityInfo(building))
                        .trafficInfo(setTrafficInfo(building))
                        .build())
                .build();
    }

    //표제부 데이터
    private BuildingEntity.BuildingInfo setBuildingInfo(BuildingEntity building){
        //표제부 데이터
        MasterRegisterEntity masterRegisterEntity = masterRegisterRepository.findByNewPlatPlcOrPlatPlc(building.getNewPlatPlc(), building.getPlatPlc())
                .orElse(null);
        if(masterRegisterEntity == null){
            return BuildingEntity.BuildingInfo.builder()
                    .platArea(0.0)
                    .archArea(0.0)
                    .totArea(0.0)
                    .bcRat(0.0)
                    .vlRat(0.0)
                    .mainPurpsCdNm("")
                    .regstrKindCd(0)
                    .regstrKindCdNm("")
                    .hhldCnt(0)
                    .mainBldCnt(0)
                    .totPkngCnt(0)
                    .build();
        }
        return BuildingEntity.BuildingInfo.builder()
                .platArea(masterRegisterEntity.getPlatArea())
                .archArea(masterRegisterEntity.getArchArea())
                .totArea(masterRegisterEntity.getTotArea())
                .bcRat(masterRegisterEntity.getBcRat())
                .vlRat(masterRegisterEntity.getVlRat())
                .mainPurpsCdNm(masterRegisterEntity.getMainPurpsCdNm())
                .regstrKindCd(masterRegisterEntity.getRegstrKindCd())
                .regstrKindCdNm(masterRegisterEntity.getRegstrKindCdNm())
                .hhldCnt(masterRegisterEntity.getHhldCnt())
                .mainBldCnt(masterRegisterEntity.getMainBldCnt())
                .totPkngCnt(masterRegisterEntity.getTotPkngCnt())
                .build();
    }
    //실거래가 데이터
    private BuildingEntity.PriceInfo setPriceInfo(BuildingEntity building){
        //전세
        List<RealTransactionPriceEntity> leaseList = realTransactionPriceRepository.findByPlatPlcAndTradeType(building.getPlatPlc(),"전세");
        long leaseTot = 0;
        double leaseAvg = 0;
        if(!leaseList.isEmpty()){
            for(RealTransactionPriceEntity entity : leaseList){
                leaseTot += Integer.parseInt(entity.getTradeAmount().replaceAll(",", ""));
            }
            leaseAvg = (double) leaseTot /leaseList.size();
        }
        //월세
        List<RealTransactionPriceEntity> rentList = realTransactionPriceRepository.findByPlatPlcAndTradeType(building.getPlatPlc(), "월세");
        long depositTot = 0;
        long rentTot = 0;
        double depositAvg = 0;
        double rentAvg = 0;
        if(!rentList.isEmpty()){
            for(RealTransactionPriceEntity entity : rentList){
                String[] tradeAmount = entity.getTradeAmount().replaceAll(",", "").split("/");
                depositTot += Integer.parseInt(tradeAmount[0]);
                rentTot += Integer.parseInt(tradeAmount[1]);
            }
            depositAvg = (double) depositTot /rentList.size();
            rentAvg = (double) rentTot/rentList.size();
        }
        //매매
        List<RealTransactionPriceEntity> saleList = realTransactionPriceRepository.findByPlatPlcAndTradeType(building.getPlatPlc(), "매매");
        long saleTot = 0;
        double saleAvg = 0;
        if(!saleList.isEmpty()){
            for(RealTransactionPriceEntity entity : saleList){
                saleTot += Integer.parseInt(entity.getTradeAmount().replaceAll(",", ""));
            }
            saleAvg = (double) saleTot / saleList.size();
        }

        return BuildingEntity.PriceInfo.builder()
                .leaseAvg(leaseAvg)
                .rentAvg(depositAvg + "/" + rentAvg)
                .saleAvg(saleAvg)
                .build();
    }
    private BuildingEntity.TrafficInfo setTrafficInfo(BuildingEntity building) {
//        return new BuildingEntity.TrafficInfo();
        return BuildingEntity.TrafficInfo.builder()
                .bus(new HashMap<String, Long>())
                .subway(new HashMap<String, Long>())
                .build();
    }

    private BuildingEntity.SecurityInfo setSecurityInfo(BuildingEntity building) {
//        return new BuildingEntity.SecurityInfo();
        return BuildingEntity.SecurityInfo.builder()
                .safetyGrade(0)
                .build();
    }

    private BuildingEntity.InfraInfo setInfraInfo(BuildingEntity building) {
//        return new BuildingEntity.InfraInfo();
        return BuildingEntity.InfraInfo.builder()
                .parks(new HashMap<String, Long>())
                .Libraries(new HashMap<String, Long>())
                .medicalFacilities(new HashMap<String, Long>())
                .schools(new HashMap<String, Long>())
                .supermarkets(new HashMap<String, Long>())
                .build();
    }
}
