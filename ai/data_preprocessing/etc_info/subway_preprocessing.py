import pandas as pd
import requests
import re
import os
from dotenv import load_dotenv

# .env 파일에서 환경 변수 로드
load_dotenv()

file_path = 'files/전체_도시철도역사정보_20240331.xlsx'

df = pd.read_excel(file_path)[['역사명', '노선명', '역위도', '역경도', '역사도로명주소']]

# '역사도로명주소' 컬럼의 모든 공백을 제거
df['역사명'] = df['역사명'].str.replace(' ', '')

check_dict = {
    '공단': '서구 팔달로 28 (비산동)',
    '삼전': '서울특별시 송파구 백제고분로 지하 189',
    '석촌고분': '서울특별시 송파구 백제고분로 지하 274',
    '한성백제': '서울특별시 송파구 위례성대로 지하 29',
    '둔촌오륜': '서울특별시 강동구 강동대로 지하 303',
    '중앙보훈병원': '서울특별시 강동구 동남로 지하 625',
    '성신여대입구': '서울특별시 성북구 동소문로 지하 102'
}

for name, address in check_dict.items():
    df.loc[df['역사명'] == name, '역사도로명주소'] = address

# API 요청 함수
def get_latitude_longitude(address):
    headers = {"Authorization": f'KakaoAK {os.getenv("KAKAO_API_KEY")}'}
    url = 'https://dapi.kakao.com/v2/local/search/address.json'
    params = {'query': address}
    response = requests.get(url, headers=headers, params=params)
    response_data = response.json()
    if response_data['documents']:
        latitude = response_data['documents'][0]['y']
        longitude = response_data['documents'][0]['x']
        print(latitude, longitude)
        return latitude, longitude
    else:
        print("위도, 경도 추출 실패..")
        return None, None

# 주소로부터 위도와 경도 좌표를 가져와서 새로운 열에 추가하는 함수
def apply_get_coordinates(row):
    # 만약 '위도'와 '경도' 열이 있고, 해당 값이 유효한 경우, 이를 사용합니다.
    if '역위도' in row and '역경도' in row and pd.notnull(row['역위도']) and pd.notnull(row['역경도']):
        latitude = row['역위도']
        longitude = row['역경도']
    else:
        # 값이 없는 경우, 주소를 사용하여 위도와 경도를 받아옵니다.
        latitude, longitude = get_latitude_longitude(row['역사도로명주소'])
    return pd.Series([latitude, longitude], index=['latitude', 'longitude'])

def standardize_station_name(name):
    # 괄호와 괄호 안의 내용 제거
    name = re.sub(r'\(.*\)', '', name)
    # 마지막 단어가 '역'인 경우에만 '역' 제거
    name = re.sub(r'역$', '', name)
    # 양쪽 공백 제거
    name = name.strip()
    return name

# apply 함수를 사용하여 각 행에 apply_get_coordinates 함수 적용
coordinates = df.apply(apply_get_coordinates, axis=1)
df = pd.concat([df, coordinates], axis=1)

df = df.drop(columns=['역위도', '역경도'], axis=1)

# '역사명' 컬럼을 표준화
df['역사명'] = df['역사명'].apply(standardize_station_name)

# 이제 '역사명'을 기준으로 데이터를 그룹화 한 후, 집계
df = df.groupby('역사명').agg({
    # 필요한 컬럼을 집계합니다. 예를 들어:
    '노선명': lambda x: ', '.join(sorted(set(x))),
    'latitude': 'first',
    'longitude': 'first',
    '역사도로명주소': 'first'
}).reset_index()

df['역사명'] = df['역사명'].apply(lambda name: name if name.endswith('역') else name + '역')

df.rename(columns={'역사도로명주소': 'station_address', '역사명': 'station_name', '노선명': 'station_line_name'}, inplace=True)
print(df)

df.to_csv('files/subway.csv', index=False)
