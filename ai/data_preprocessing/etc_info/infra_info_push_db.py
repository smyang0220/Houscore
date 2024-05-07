import pandas as pd
import os
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.types import Text, Integer, Float
from dotenv import load_dotenv

# .env 파일에서 환경 변수 로드
load_dotenv()

# PostgreSQL 연결
engine = create_engine(
    f'postgresql://{os.getenv("POSTGRES_USER")}:{os.getenv("POSTGRES_PASSWORD")}@{os.getenv("POSTGRES_HOST")}:{os.getenv("POSTGRES_PORT")}/{os.getenv("POSTGRES_DB")}')


def insert_db(df, dtypes, table_name):
    try:
        with engine.connect() as connection:
            transaction = connection.begin()

            # 데이터프레임을 SQL 테이블로 저장하고, 필요한 경우 기본 키를 설정하거나 ID 컬럼 추가
            df.to_sql(table_name, con=connection, if_exists='replace', index=False, dtype=dtypes)

            connection.execute(text(f'ALTER TABLE {table_name} ADD COLUMN id SERIAL PRIMARY KEY;'))
            transaction.commit()

            print("complete!")

    except SQLAlchemyError as e:
        print("An error occurred:", e)
        # 오류 발생 시 롤백
        transaction.rollback()


# 치안 DB 적재 (safe_rank)
# df_safety = pd.read_csv('files/dataset/치안/safe_area_rank.csv',
#                         dtype={'area': str, 'crime_rank': int, 'sigungu_code': str}, encoding='cp949')
# dtype_safety = {'area': Text, 'crime_rank': Integer, 'sigungu_code': Text}
# table_name_safety = "safe_rank"
#
# insert_db(df_safety, dtype_safety, table_name_safety)

# 교통 DB 적재 (bus)
# df_bus = pd.read_csv('files/dataset/인프라/교통/bus.csv', dtype={'bus_stop_name': str, 'latitude': float, 'longitude': float})[['bus_stop_name','latitude','longitude']]
# dtype_bus = {'bus_stop_name': Text, 'latitude': Float , 'longitude': Float}
# table_name_bus = "bus"
#
# insert_db(df_bus, dtype_bus, table_name_bus)

# 교통 DB 적재 (subway)
# df_subway = pd.read_csv('files/dataset/인프라/교통/subway.csv', dtype={'station_name': str, 'station_line_name': str, 'latitude': float, 'longitude': float,'plat_plc':str},encoding='cp949')
# dtype_subway = {'station_name': Text, 'station_line_name': Text, 'latitude': Float, 'longitude': Float,'station_address':Text}
# table_name_subway = "subway"
#
# insert_db(df_subway, dtype_subway, table_name_subway)

# 학군 DB 적재 (school)
# df_elementary = pd.read_csv('files/dataset/인프라/학군/school.csv',
#                             dtype={'school_name': str, 'school_type': str, 'latitude': float, 'longitude': float,
#                                    'plat_plc': str, 'new_plat_plc': str}, encoding='cp949')
# dtype_elementary = {'station_name': Text, 'school_type': Text, 'latitude': Float, 'longitude': Float,
#                     'plat_plc': Text, 'new_plat_plc': Text}
# table_elementary = "school"
#
# insert_db(df_elementary, dtype_elementary, table_elementary)

# 학원 DB 적재 (academy)
# df_academy = pd.read_csv('files/dataset/인프라/학원/academy.csv',
#                          dtype={'academy_name': str, 'new_plat_plc': str, 'latitude': float, 'longitude': float})
#
# dtype_academy = {'academy_name': Text, 'new_plat_plc': Text, 'latitude': Float, 'longitude': Float}
# table_academy = "academy"
#
# insert_db(df_academy, dtype_academy, table_academy)

# 병원 DB 적재 (hospital)
# df_hospital = pd.read_csv('files/dataset/인프라/편의시설/hospital.csv',
#                           dtype={'hospital_name': str, 'hospital_type': str, 'latitude': float, 'longitude': float,
#                                  'plat_plc': str, 'diagnosis_type': str}, encoding='cp949')
#
# dtype_hospital = {'hospital_name': Text, 'hospital_type': Text, 'latitude': Float, 'longitude': Float, 'plat_plc': Text,
#                   'diagnosis_type': Text}
# table_hospital = "hospital"
#
# insert_db(df_hospital, dtype_hospital, table_hospital)

# 세탁소 DB 적재 (laundry)
# df_laundry = pd.read_csv('files/dataset/인프라/편의시설/laundry.csv',
#                          dtype={'plat_plc': str, 'new_plat_plc': str, 'laundry_name': str, 'latitude': float,
#                                 'longitude': float}, encoding='cp949')
#
# dtype_laundry = {'plat_plc': Text, 'new_plat_plc': Text, 'laundry_name': Text, 'latitude': Float,'longitude': Float}
# table_laundry = "laundry"
#
# insert_db(df_laundry, dtype_laundry, table_laundry)

# 도서관 DB 적재 (library)
# df_library = pd.read_csv('files/dataset/인프라/편의시설/library.csv',
#                          dtype={'new_plat_plc': str, 'library_name': str, 'latitude': float, 'longitude': float},
#                          encoding='cp949')
#
# dtype_library = {'new_plat_plc': Text, 'library_name': Text, 'latitude': Float, 'longitude': Float}
# table_library = "library"
#
# insert_db(df_library, dtype_library, table_library)

# 공원 DB 적재 (park)
# df_park = pd.read_csv('files/dataset/인프라/편의시설/park.csv',
#                       dtype={'plat_plc': str, 'park_name': str, 'latitude': float, 'longitude': float})
#
# dtype_park = {'plat_plc': Text, 'park_name': Text, 'latitude': Float, 'longitude': Float}
# table_park = "park"
#
# insert_db(df_park, dtype_park, table_park)

# 대형마트 DB 적재 (store)
# df_store = pd.read_csv('files/dataset/인프라/편의시설/store.csv',
#                        dtype={'plat_plc': str, 'new_plat_plc': str, 'store_name': str, 'latitude': float,
#                               'longitude': float},
#                        encoding='cp949')
#
# dtype_store = {'plat_plc': Text, 'new_plat_plc': Text, 'store_name': Text, 'latitude': Float, 'longitude': Float}
# table_store = "store"
#
# insert_db(df_store, dtype_store, table_store)
