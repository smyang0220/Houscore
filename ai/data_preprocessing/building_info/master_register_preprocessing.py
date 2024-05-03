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

# 파일 경로 지정
file_path = 'files/dataset/원본데이터/표제부데이터셋/총괄표제부.txt'

field_mapping = {
    "대지면적": "plat_area",
    "건축면적": "arch_area",
    "건폐율": "bc_rat",
    "연면적": "tot_area",
    "용적률": "vl_rat",
    "주용도코드명": "main_purps_cd_nm",
    "생성일자": "crtn_day",
    "세대수": "hhld_cnt",
    "주건축물수": "main_bld_cnt",
    "총주차수": "tot_pkng_cnt",
    "대지위치": "plat_plc",
    "시군구코드": "sigungu_cd",
    "법정동코드": "bjdong_cd",
    "도로명대지위치": "new_plat_plc",
    "건물명": "bld_nm",
    '대장종류코드': 'regstr_kind_cd',
    '대장종류코드명': 'regstr_kind_cd_nm',
}

# 헤더 리스트 생성
headers = [
    "관리건축물대장PK",
    "대장구분코드",
    "대장구분코드명",
    "대장종류코드",
    "대장종류코드명",
    "신구대장구분코드",
    "신구대장구분코드명",
    "대지위치",
    "도로명대지위치",
    "건물명",
    "시군구코드",
    "법정동코드",
    "대지구분코드",
    "번",
    "지",
    "특수지명",
    "블록",
    "로트",
    "외필지수",
    "새주소도로코드",
    "새주소법정동코드",
    "새주소지상지하코드",
    "새주소본번",
    "새주소부번",
    "대지면적",
    "건축면적",
    "건폐율",
    "연면적",
    "용적률산정연면적",
    "용적률",
    "주용도코드",
    "주용도코드명",
    "기타용도",
    "세대수",
    "가구수",
    "주건축물수",
    "부속건축물수",
    "부속건축물면적",
    "총주차수",
    "옥내기계식대수",
    "옥내기계식면적",
    "옥외기계식대수",
    "옥외기계식면적",
    "옥내자주식대수",
    "옥내자주식면적",
    "옥외자주식대수",
    "옥외자주식면적",
    "허가일",
    "착공일",
    "사용승인일",
    "허가번호년",
    "허가번호기관코드",
    "허가번호기관코드명",
    "허가번호구분코드",
    "허가번호구분코드명",
    "호수",
    "에너지효율등급",
    "에너지절감율",
    "EPI점수",
    "친환경건축물등급",
    "친환경건축물인증점수",
    "지능형건축물등급",
    "지능형건축물인증점수",
    "생성일자"
]


# pnu 코드를 만드는 함수
def create_pnu(row):
    # 대장구분코드 조건에 따라 변환
    if row['대지구분코드'] == '0':
        plat_code = '1'
    elif row['대지구분코드'] == '1':
        plat_code = '2'
    else:
        return None

    # '번'과 '지'를 문자열로 강제 변환하고 zfill로 패딩 추가
    bun = str(int(row['번'])).zfill(4)
    ji = str(int(row['지'])).zfill(4)
    return f"{row['시군구코드']}{row['법정동코드']}{plat_code}{bun}{ji}"


# 데이터프레임으로 읽어오기
df = pd.read_csv(file_path, delimiter='|', encoding='cp949', names=headers,
                 dtype={'법정동코드': str, '시군구코드': str, '대지구분코드': str, '번': str, '지': str})

# 'address' 열에서 '번지' 문자열 제거
df['대지위치'] = df['대지위치'].str.replace('번지', '', regex=False)

# 단독주택, 공동주택만 추리기
df = df[df['주용도코드명'].isin(['공동주택', '다중주택', '단독주택', '다세대주택', '다가구주택', '연립주택', '아파트'])]

# pnu 코드 생성 전에 NaN 값이 있는 행을 제거
df.dropna(subset=['시군구코드', '법정동코드', '대지구분코드', '번', '지'], inplace=True)

# 새로운 pnu 코드 컬럼 추가
df['pnu_code'] = df.apply(create_pnu, axis=1)

# 일반, 산이 아닌경우 None을 넣어 제거
df.dropna(subset=['pnu_code'], inplace=True)

# 데이터프레임 제거 컬럼 선정 후 제거
df = df[['대지면적', '건축면적', '건폐율', '연면적', '용적률', '주용도코드명', '생성일자', '대장종류코드', '대장종류코드명', '세대수', '주건축물수', '총주차수', '대지위치',
         '시군구코드', '법정동코드', '도로명대지위치', '건물명', 'pnu_code']]

# 문자열을 포함하고 있는 열만 확인하여 앞뒤 공백 찍힌거 제거
for column in df.columns:
    if df[column].dtype == 'object':
        df[column] = df[column].str.strip()

# 날짜 열을 datetime 형식으로 변환
df['생성일자'] = pd.to_datetime(df['생성일자'], format='%Y%m%d')

# 각 pnu_code 그룹에서 생성일자의 최대값을 찾기
max_dates = df.groupby('pnu_code')['생성일자'].transform('max')

# 최대값과 일치하는 모든 행을 선택하기
df = df[df['생성일자'] == max_dates]

# 생성일자가 같아 2개이상이 반영된 pnu_code를 위해 중복 제거
df = df.drop_duplicates(subset=['pnu_code'], keep='first')

# 데이터프레임 컬럼명 영문으로 변경
df.rename(columns=field_mapping, inplace=True)

# 전처리된 데이터프레임 확인
print(df.head(), len(df))

df.to_csv('files/dataset/건물정보/전처리_총괄표제부.csv', index=False, encoding='utf-8')
df = pd.read_csv('files/dataset/건물정보/전처리_총괄표제부.csv')

print("데이터 적재 시작")

try:
    with engine.connect() as connection:
        transaction = connection.begin()

        # 데이터프레임을 SQL 테이블로 저장하고, 필요한 경우 기본 키를 설정하거나 ID 컬럼 추가
        df.to_sql('master_register', con=connection, if_exists='replace', index=False,
                  dtype={'plat_area': Float, 'arch_area': Float, 'bc_rat': Float, 'tot_area': Float, 'vl_rat': Float,
                         'main_purps_cd_nm': Text, 'crtn_day': DateTime, 'regstr_kind_cd': Integer,
                         'regstr_kind_cd_nm': Text,
                         'hhld_cnt': Integer, 'main_bld_cnt': Integer, 'tot_pkng_cnt': Integer, 'plat_plc': Text,
                         'sigungu_cd': Text, 'bjdong_cd': Text, 'new_plat_plc': Text, 'bld_nm': Text, 'pnu_code': Text})

        connection.execute(text(f'ALTER TABLE master_register ADD COLUMN id SERIAL PRIMARY KEY;'))

        transaction.commit()

except SQLAlchemyError as e:
    print("An error occurred:", e)
    # 오류 발생 시 롤백
    transaction.rollback()
