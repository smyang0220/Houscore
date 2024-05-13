package com.hs.houscore.batch.processor;

import com.hs.houscore.batch.entity.MasterRegisterEntity;
import com.hs.houscore.batch.entity.RealTransactionPriceEntity;
import com.hs.houscore.batch.entity.SafeRankEntity;
import com.hs.houscore.batch.repository.*;
import com.hs.houscore.mongo.entity.BuildingEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
public class BuildingItemProcessor implements ItemProcessor<BuildingEntity, BuildingEntity> {

    private final MasterRegisterRepository masterRegisterRepository;
    private final RealTransactionPriceRepository realTransactionPriceRepository;
    private final BusRepository busRepository;
    private final SubwayRepository subwayRepository;
    private final HospitalRepository hospitalRepository;
    private final LibraryRepository libraryRepository;
    private final ParkRepository parkRepository;
    private final SchoolRepository schoolRepository;
    private final StoreRepository storeRepository;
    private final SafeRankRepository safeRankRepository;

    @Override
    public BuildingEntity process(BuildingEntity building) throws Exception {
        //배치를 처리할 로직이 들어가는 부분

        return BuildingEntity.builder()
                .id(building.getId())
                .score(building.getScore())
                .location(building.getLocation())
                .platPlc(building.getPlatPlc())
                .newPlatPlc(building.getNewPlatPlc())
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
                    .sigunguCd("")
                    .bjdongCd("")
                    .bldNm("")
                    .pnuCode("")
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
                .sigunguCd(masterRegisterEntity.getSigunguCd())
                .bjdongCd(masterRegisterEntity.getBjdongCd())
                .bldNm(masterRegisterEntity.getBldNm())
                .pnuCode(masterRegisterEntity.getPnuCode())
                .build();
    }
    //실거래가 데이터
    private BuildingEntity.PriceInfo setPriceInfo(BuildingEntity building){
        //전세
        List<RealTransactionPriceEntity> leaseList = realTransactionPriceRepository.findByPlatPlcAndTradeType(building.getPlatPlc(),"전세");
        long leaseTot = 0;
        long leaseAvg = 0;
        if(!leaseList.isEmpty()){
            for(RealTransactionPriceEntity entity : leaseList){
                leaseTot += Integer.parseInt(entity.getTradeAmount().replaceAll(",", ""));
            }
            leaseAvg = leaseTot /leaseList.size();
        }
        //월세
        List<RealTransactionPriceEntity> rentList = realTransactionPriceRepository.findByPlatPlcAndTradeType(building.getPlatPlc(), "월세");
        long depositTot = 0;
        long rentTot = 0;
        long depositAvg = 0;
        long rentAvg = 0;
        if(!rentList.isEmpty()){
            for(RealTransactionPriceEntity entity : rentList){
                String[] tradeAmount = entity.getTradeAmount().replaceAll(",", "").split("/");
                depositTot += Integer.parseInt(tradeAmount[0]);
                rentTot += Integer.parseInt(tradeAmount[1]);
            }
            depositAvg = depositTot /rentList.size();
            rentAvg = rentTot/rentList.size();
        }
        //매매
        List<RealTransactionPriceEntity> saleList = realTransactionPriceRepository.findByPlatPlcAndTradeType(building.getPlatPlc(), "매매");
        long saleTot = 0;
        long saleAvg = 0;
        if(!saleList.isEmpty()){
            for(RealTransactionPriceEntity entity : saleList){
                saleTot += Integer.parseInt(entity.getTradeAmount().replaceAll(",", ""));
            }
            saleAvg = saleTot / saleList.size();
        }

        return BuildingEntity.PriceInfo.builder()
                .leaseAvg(leaseAvg)
                .rentAvg(depositAvg + "/" + rentAvg)
                .saleAvg(saleAvg)
                .build();
    }
    private BuildingEntity.TrafficInfo setTrafficInfo(BuildingEntity building) {
        List<Object[]> bus = busRepository.findBusByDistance(building.getLocation().getY(),building.getLocation().getX(),1000);
        List<Map<String, Object>> busMap = getBusMap(bus);

        List<Object[]> subway = subwayRepository.findSubwayByDistance(building.getLocation().getY(),building.getLocation().getX(),1000);
        List<Map<String, Object>> subwayMap = getSubwayMap(subway);

        return BuildingEntity.TrafficInfo.builder()
                .bus(busMap)
                .subway(subwayMap)
                .build();
    }

    private BuildingEntity.SecurityInfo setSecurityInfo(BuildingEntity building) {
        // 두 번째 공백까지의 문자열만 추출
        String address = building.getPlatPlc();
        String area = "";
        int secondSpaceIndex = address.indexOf(" ", address.indexOf(" ") + 1);
        if (secondSpaceIndex != -1) {
            area = address.substring(0, secondSpaceIndex);
        }
        SafeRankEntity safeRank = safeRankRepository.findByAreaContaining(area);
        return BuildingEntity.SecurityInfo.builder()
                .safetyGrade(safeRank != null ? safeRank.getCrimeRank() : 0)
                .build();
    }

    private BuildingEntity.InfraInfo setInfraInfo(BuildingEntity building) {
        List<Object[]> hospital = hospitalRepository.findHospitalByDistance(building.getLocation().getY(),building.getLocation().getX(),700);
        List<Map<String, Object>> hospitalMap = getHospitalMap(hospital);

        List<Object[]> library = libraryRepository.findLibraryByDistance(building.getLocation().getY(),building.getLocation().getX(),700);
        List<Map<String, Object>> libraryMap = getLibraryMap(library);

        List<Object[]> park = parkRepository.findParkByDistance(building.getLocation().getY(),building.getLocation().getX(),700);
        List<Map<String, Object>> parkMap = getParkMap(park);

        List<Object[]> school = schoolRepository.findSchoolByDistance(building.getLocation().getY(),building.getLocation().getX(),700);
        List<Map<String, Object>> schoolMap = getSchoolMap(school);

        List<Object[]> store = storeRepository.findStoreByDistance(building.getLocation().getY(),building.getLocation().getX(),700);
        List<Map<String, Object>> storeMap = getStoreMap(store);

        return BuildingEntity.InfraInfo.builder()
                .parks(parkMap)
                .Libraries(libraryMap)
                .medicalFacilities(hospitalMap)
                .schools(schoolMap)
                .supermarkets(storeMap)
                .build();
    }

    private static List<Map<String, Object>> getBusMap(List<Object[]> bus) {
        List<Map<String, Object>> busMap = new ArrayList<>();
        if(bus != null && !bus.isEmpty()){
            for (Object[] data : bus) {
                String busStopName = (String) data[0];
                Double distance = (Double) data[4];

                Map<String, Object> entryMap = new HashMap<>();
                entryMap.put("name", busStopName);
                entryMap.put("distance", distance.longValue());

                busMap.add(entryMap);
            }
        }
        return busMap;
    }

    private static List<Map<String, Object>> getSubwayMap(List<Object[]> subway) {
        List<Map<String, Object>> subwayMap = new ArrayList<>();
        if(subway != null && !subway.isEmpty()){
            for (Object[] data : subway) {
                String stationName = (String) data[0];
                String lineName = (String) data[1];
                Double distance = (Double) data[6];

                Map<String, Object> entryMap = new HashMap<>();
                entryMap.put("name", stationName + "("  + lineName + ")");
                entryMap.put("distance", distance.longValue());

                subwayMap.add(entryMap);
            }
        }
        return subwayMap;
    }

    private static List<Map<String, Object>> getHospitalMap(List<Object[]> hospital) {
        List<Map<String, Object>> hospitalMap = new ArrayList<>();
        if(hospital != null && !hospital.isEmpty()){
            for (Object[] data : hospital) {
                String hospitalName = (String) data[0];
                Double distance = (Double) data[7];

                Map<String, Object> entryMap = new HashMap<>();
                entryMap.put("name", hospitalName);
                entryMap.put("distance", distance.longValue());

                hospitalMap.add(entryMap);
            }
        }
        return hospitalMap;
    }

    private static List<Map<String, Object>> getLibraryMap(List<Object[]> library) {
        List<Map<String, Object>> libraryMap = new ArrayList<>();
        if(library != null && !library.isEmpty()){
            for (Object[] data : library) {
                String libraryName = (String) data[0];
                Double distance = (Double) data[5];

                Map<String, Object> entryMap = new HashMap<>();
                entryMap.put("name", libraryName);
                entryMap.put("distance", distance.longValue());

                libraryMap.add(entryMap);
            }
        }
        return libraryMap;
    }

    private static List<Map<String, Object>> getParkMap(List<Object[]> park) {
        List<Map<String, Object>> parkMap = new ArrayList<>();
        if(park != null && !park.isEmpty()){
            for (Object[] data : park) {
                String parkName = (String) data[0];
                Double distance = (Double) data[5];

                Map<String, Object> entryMap = new HashMap<>();
                entryMap.put("name", parkName);
                entryMap.put("distance", distance.longValue());

                parkMap.add(entryMap);
            }
        }
        return parkMap;
    }
    private static List<Map<String, Object>> getSchoolMap(List<Object[]> school) {
        List<Map<String, Object>> schoolMap = new ArrayList<>();
        if(school != null && !school.isEmpty()){
            for (Object[] data : school) {
                String schoolName = (String) data[0];
                Double distance = (Double) data[7];

                Map<String, Object> entryMap = new HashMap<>();
                entryMap.put("name", schoolName);
                entryMap.put("distance", distance.longValue());

                schoolMap.add(entryMap);
            }
        }
        return schoolMap;
    }
    private static List<Map<String, Object>> getStoreMap(List<Object[]> store) {
        List<Map<String, Object>> storeMap = new ArrayList<>();
        if(store != null && !store.isEmpty()){
            for (Object[] data : store) {
                String storeName = (String) data[2];
                Double distance = (Double) data[6];

                Map<String, Object> entryMap = new HashMap<>();
                entryMap.put("name", storeName);
                entryMap.put("distance", distance.longValue());

                storeMap.add(entryMap);
            }
        }
        return storeMap;
    }
}
