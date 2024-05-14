import pandas as pd
import requests, os
from dotenv import load_dotenv

# 필요한 패키지 설치 안내
# !pip install pandas
# !pip install requests
# vworld API 키를 요청해야 하며, 회원가입 필요 (https://www.vworld.kr/v4po_main.do)
load_dotenv()  # 환경 변수 로드

# 환경 변수에서 API 키 읽기
API_KEY = os.getenv('VWORLD_API_KEY')

file_path = 'test.csv'
df = pd.read_csv(file_path)

if 'longitude' not in df.columns:
    df['longitude'] = None
if 'latitude' not in df.columns:
    df['latitude'] = None

# API 요청 함수 - 도로명주소용
def get_coordinates_road(address):
    apiurl = "https://api.vworld.kr/req/address?"
    params = {
        "service": "address",
        "request": "getcoord",
        "crs": "epsg:4326",
        "address": address,
        "format": "json",
        "type": "ROAD",
        "simple": "true",
        "key": API_KEY #"  # API 키는 적절히 대체해 주세요.
    }
    return send_request(apiurl, params)

# API 요청 함수 - 소재지주소용
def get_coordinates_parcel(address):
    apiurl = "https://api.vworld.kr/req/address?"
    params = {
        "service": "address",
        "request": "getcoord",
        "crs": "epsg:4326",
        "address": address,
        "format": "json",
        "type": "PARCEL",
        "simple": "true",
        "key": API_KEY # API 키는 적절히 대체해 주세요.
    }
    return send_request(apiurl, params)

def send_request(apiurl, params):
    try:
        response = requests.get(apiurl, params=params)
        if response.status_code == 200:
            response_json = response.json()
            if response_json['response']['status'] == 'OK':
                longitude = response_json['response']['result']['point']['x']
                latitude = response_json['response']['result']['point']['y']
                return longitude, latitude
    except Exception as e:
        print(f"Error fetching coordinates: {e}")
    return None, None

# 지오코딩 프로세스 실행
for index, row in df.iterrows():
    if pd.isna(row['latitude']):  # 위도 값이 없는 경우에만 API 호출
        address = row['new_plat_plc']
        lon, lat = None, None
        if pd.notna(address):  # 도로명주소가 있으면 도로명주소 API 사용
            lon, lat = get_coordinates_road(address)
        if (lon is None or lat is None) and pd.notna(row['plat_plc']):  # 도로명주소로 찾지 못했고 소재지주소가 있으면 소재지주소 API 사용
            address = row['plat_plc']
            lon, lat = get_coordinates_parcel(address)

        if lon and lat:
            df.at[index, 'longitude'] = lon
            df.at[index, 'latitude'] = lat
        else:
            print(f"Address not found or error for: {address}")

    if (index + 1) % 100 == 0:
        print(f"Processed {index + 1} addresses.")

# 결과 파일로 저장
df.to_csv('updated_example.csv', index=False, encoding='cp949')

# 결과 출력
print('Processing complete')