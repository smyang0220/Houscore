import uvicorn
from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
import pandas as pd
import joblib
import logging
import requests
import os
from dotenv import load_dotenv
import traceback
import sys
from typing import List, Optional
import numpy as np


class Location(BaseModel):
    x: float
    y: float
    type: str
    coordinates: List[float]


class IdField(BaseModel):
    timestamp: int
    date: int


class BuildingInfo(BaseModel):
    platArea: float
    archArea: float
    totArea: float
    bcRat: float
    vlRat: float
    mainPurpsCdNm: str
    regstrKindCd: int
    regstrKindCdNm: str
    hhldCnt: int
    mainBldCnt: int
    totPkngCnt: int
    sigunguCd: str
    bjdongCd: str
    bldNm: Optional[str] = None
    pnuCode: str


class Facility(BaseModel):
    distance: float
    name: str


class InfraInfo(BaseModel):
    medicalFacilities: List[Facility] = []
    parks: List[Facility] = []
    schools: List[Facility] = []
    libraries: List[Facility] = []
    supermarkets: List[Facility] = []
    laundry: List[Facility] = []


class PriceInfo(BaseModel):
    leaseAvg: int
    rentAvg: str
    saleAvg: int
    individualPubliclyAnnouncedPrice: List[int] = []


class SecurityInfo(BaseModel):
    safetyGrade: int


class TrafficInfo(BaseModel):
    bus: List[Facility]
    subway: List[Facility]


class Information(BaseModel):
    buildingInfo: BuildingInfo
    infraInfo: InfraInfo
    securityInfo: SecurityInfo
    trafficInfo: TrafficInfo
    priceInfo: PriceInfo


class PredictionRequest(BaseModel):
    id: IdField
    score: Optional[float] = None
    location: Location
    platPlc: str
    newPlatPlc: str
    batchYn: str
    information: Information


# .env 파일에서 환경 변수 로드
load_dotenv()


def send_mattermost_notification(message):
    formatted_message = f'```\n{message}\n```'
    data = {'text': formatted_message}
    webhook_url = os.getenv("MATTERMOST_WEB_HOOK_URL")
    if webhook_url:
        requests.post(webhook_url, json=data)


def extract_min_distance(items):
    # 첫 번째 'distance' 값을 찾아 반환
    for item in items:
        if 'distance' in item:
            return item['distance']
    return 1  # 'distance' 키를 가진 항목이 없을 경우


app = FastAPI()

# 모델 로드
model = joblib.load('models/model.pkl')
feature_names = model.feature_names_in_
feature_names.remove('label')


@app.post("/predict")
async def predict(request: PredictionRequest):
    try:
        send_mattermost_notification(request)
        info = request.information

        official_price = info.priceInfo.individualPubliclyAnnouncedPrice

        if 'official_price' in feature_names and official_price:
            official_price = official_price[0]
        else:
            return float(-1)

        if (info.buildingInfo.bcRat == 0 or
                info.buildingInfo.vlRat == 0 or
                info.buildingInfo.hhldCnt == 0 or
                info.securityInfo.safetyGrade == 0):
            return float(-1)

        df = pd.DataFrame([{
            "plat_area": info.buildingInfo.platArea,
            "arch_area": info.buildingInfo.archArea,
            "tot_area": info.buildingInfo.totArea,
            "bc_rat": info.buildingInfo.bcRat,
            "vl_rat": info.buildingInfo.vlRat,
            "hhld_cnt": info.buildingInfo.hhldCnt,
            "tot_pkng_cnt": info.buildingInfo.totPkngCnt,
            "crime_rank": info.securityInfo.safetyGrade,
            "nearest_medical_related": extract_min_distance(info.infraInfo.medicalFacilities),
            "nearest_laundry_related": extract_min_distance(info.infraInfo.laundry),
            "nearest_park_related": extract_min_distance(info.infraInfo.parks),
            "nearest_market_related": extract_min_distance(info.infraInfo.supermarkets),
            "nearest_bus_stop_related": extract_min_distance(info.trafficInfo.bus),
            "nearest_subway_related": extract_min_distance(info.trafficInfo.subway),
            "official_price": official_price,
        }])

        df['pkng_cnt_per_hhld_cnt'] = df['tot_pkng_cnt'] / df['hhld_cnt'] if df['hhld_cnt'].any() else 0
        df['nearest_transit_related'] = np.minimum(df['nearest_bus_stop_related'], df['nearest_subway_related'])

        filtered_df = df[feature_names]

        prediction = model.predict(filtered_df)

        # 정상적인 처리 또는 다른 계산 진행
        return float(prediction[0])

    except Exception as e:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        traceback_details = traceback.format_exception(exc_type, exc_value, exc_traceback)
        error_message = f"Error during prediction: {''.join(traceback_details)}"
        logging.error(error_message, exc_info=True)
        send_mattermost_notification(error_message)
        # raise HTTPException(status_code=500, detail=str(e))
        return float(-1)


if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=8000)
