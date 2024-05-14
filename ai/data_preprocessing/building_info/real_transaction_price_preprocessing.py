import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.types import Integer, Text, Float, DateTime
from dotenv import load_dotenv
import os

# .env 파일에서 환경 변수 로드
load_dotenv()

# PostgreSQL 연결
engine = create_engine(
    f'postgresql://{os.getenv("POSTGRES_USER")}:{os.getenv("POSTGRES_PASSWORD")}@{os.getenv("POSTGRES_HOST")}:{os.getenv("POSTGRES_PORT")}/{os.getenv("POSTGRES_DB")}')

file_path = 'files/dataset/원본데이터/실거래가/거래내역(2021-2024.3)/transaction_history_2021_2024_cp949.csv'

df = pd.read_csv(file_path, encoding='CP949',
                 dtype={'sigungu': str, 'bunji': str, 'contract_year_month': str, 'contract_day': str},
                 low_memory=False)

df.dropna(
    subset=['sigungu', 'bunji', 'contract_year_month', 'contract_day', 'trade_amount', 'area', 'floor', 'house_type',
            'trade_type'], inplace=True)

df['plat_plc'] = df['sigungu'].astype(str).strip() + " " + df['bunji'].astype(str).strip()
df['contract_date'] = pd.to_datetime(df['contract_year_month'] + df['contract_day'], format='%Y%m%d')

df = df[['plat_plc', 'bld_nm', 'contract_date', 'area', 'floor', 'house_type', 'trade_type', 'trade_amount']]

print(df)

df.to_csv('files/dataset/건물정보/전처리_실거래가.csv', index=False, encoding='utf-8')

df = pd.read_csv('files/dataset/건물정보/전처리_실거래가.csv')

try:
    with engine.connect() as connection:
        transaction = connection.begin()

        # 데이터프레임을 SQL 테이블로 저장하고, 필요한 경우 기본 키를 설정하거나 ID 컬럼 추가
        df.to_sql('real_transaction_price', con=connection, if_exists='replace', index=False,
                  dtype={'plat_plc': Text, 'bld_nm': Text, 'contract_date': DateTime, 'area': Float, 'floor': Integer,
                         'house_type': Text, 'trade_type': Text, 'trade_amount': Text})

        connection.execute(text(f'ALTER TABLE real_transaction_price ADD COLUMN id SERIAL PRIMARY KEY;'))

        transaction.commit()

except SQLAlchemyError as e:
    print("An error occurred:", e)
    # 오류 발생 시 롤백
    transaction.rollback()
