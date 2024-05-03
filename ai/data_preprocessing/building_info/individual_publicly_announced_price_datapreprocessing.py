import pandas as pd
import os
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.types import Text, BigInteger, DateTime
from dotenv import load_dotenv

# .env 파일에서 환경 변수 로드
load_dotenv()

# PostgreSQL 연결
engine = create_engine(
    f'postgresql://{os.getenv("POSTGRES_USER")}:{os.getenv("POSTGRES_PASSWORD")}@{os.getenv("POSTGRES_HOST")}:{os.getenv("POSTGRES_PORT")}/{os.getenv("POSTGRES_DB")}')

# CSV 파일이 있는 폴더
folder_path = 'files/dataset/원본데이터/공시지가/개별공시지가'

# 폴더 내의 모든 CSV 파일 리스트
csv_files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

# 모든 CSV 파일을 DataFrame으로 읽어서 리스트에 저장
df_list = [pd.read_csv(os.path.join(folder_path, file), encoding='cp949', dtype={'고유번호': str, '기준연도': str, '기준월': str})
           for file in csv_files]

# 모든 DataFrame을 하나로 병합
df = pd.concat(df_list, ignore_index=True)

print(df)

# 가공하는 것 중에 결측치 제거
df.dropna(subset=['기준연도', '기준월', '데이터기준일자', '지번', '법정동명', '공시지가', '고유번호'], inplace=True)

# 결과를 새로운 CSV 파일로 저장
df.to_csv('files/dataset/건물정보/개별공시지가.csv', index=False, encoding='cp949')
print(df)

df['기준연도'] = df['기준연도'].astype(str)
df['기준월'] = df['기준월'].astype(str).str.zfill(2)

df['announced_date'] = pd.to_datetime(df['기준연도'] + df['기준월'], format='%Y%m')

# 데이터기준일자가 datetime 형태가 아니라면 변환
df['데이터기준일자'] = pd.to_datetime(df['데이터기준일자'])

# 주소 컬럼 추가
# Correctly apply strip to the entire Series
df['plat_plc'] = df['법정동명'].astype(str).str.strip() + " " + df['지번'].astype(str).str.strip()

# 공시일자와 announced_date를 기준으로 데이터 정렬
df_sorted = df.sort_values(by=['데이터기준일자', 'announced_date'], ascending=[False, False])

# 고유번호 별로 그룹화하고 각 그룹의 첫 번째 데이터 선택
result = df_sorted.groupby('고유번호').head(1)

result = result[['고유번호', 'plat_plc', '공시지가', 'announced_date', '데이터기준일자']]

# 필요한 컬럼 이름 변경
result.rename(columns={'공시지가': 'official_price', '고유번호': 'pnu_code', '데이터기준일자': 'base_date'}, inplace=True)

print(result)

df = pd.read_csv('files/dataset/건물정보/전처리_개별공시지가.csv')

try:
    with engine.connect() as connection:
        transaction = connection.begin()

        # 데이터프레임을 SQL 테이블로 저장하고, 필요한 경우 기본 키를 설정하거나 ID 컬럼 추가
        df.to_sql('individual_publicly_announced_price', con=connection, if_exists='replace', index=False,
                  dtype={'pnu_code': Text, 'plat_plc': Text, 'official_price': BigInteger, 'base_date': DateTime,
                         'announced_date': DateTime})

        connection.execute(text(f'ALTER TABLE individual_publicly_announced_price ADD COLUMN id SERIAL PRIMARY KEY;'))

        transaction.commit()

except SQLAlchemyError as e:
    print("An error occurred:", e)
    # 오류 발생 시 롤백
    transaction.rollback()
