import uvicorn
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import joblib
import logging
import requests
import os
from dotenv import load_dotenv
import traceback
import sys

# .env 파일에서 환경 변수 로드
load_dotenv()


def send_mattermost_notification(message):
    formatted_message = f'```\n{message}\n```'
    data = {'text': formatted_message}
    requests.post(os.getenv("MATTERMOST_WEB_HOOK"), json=data)


app = FastAPI()

# 모델 로드
model = joblib.load('models/model.pkl')


class PredictionRequest(BaseModel):
    data: dict


@app.post("/predict")
async def predict(request: PredictionRequest):
    try:
        data = request.data
        df = pd.DataFrame([data])

        # 데이터 처리
        if 'pkng_cnt' in df.columns and 'hhld_cnt' in df.columns:
            df['pkng_cnt_per_hhld_cnt'] = df['pkng_cnt'] / df['hhld_cnt']
            df.drop(['pkng_cnt', 'hhld_cnt'], axis=1, inplace=True)

        # 모델 예측 수행
        prediction = model.predict(df)
        return {"prediction": prediction.tolist()}

    except Exception as e:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        traceback_details = traceback.format_exception(exc_type, exc_value, exc_traceback)
        error_message = f"Error during prediction: {''.join(traceback_details)}"

        # Mattermost에 코드 블록 형태의 에러 알림 보내기
        logging.error(error_message, exc_info=True)
        send_mattermost_notification(error_message)
        raise HTTPException(status_code=400, detail=str(e))


if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=8000)
