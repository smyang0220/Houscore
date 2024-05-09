import pandas as pd
from geopy.distance import geodesic
import time

def load_building_data(filepath):
    """
    CSV 파일에서 건물 데이터를 로드합니다.
    
    Parameters:
    - filepath (str): 파일 경로
    
    Returns:
    - DataFrame: 건물 데이터가 포함된 DataFrame
    - utf-8 혹은 cp949 파일이므로 try,except를 이용해서 진행할 예정.
    """
    try:
        return pd.read_csv(filepath, encoding='utf-8')
    except UnicodeDecodeError:
        return pd.read_csv(filepath, encoding='cp949')

def filter_and_sort_buildings(center_coord, buildings_df, radius_km):
    """
    주어진 반경 내의 건물들을 필터링하고 거리 순으로 정렬합니다.
    
    Parameters:
    - center_coord (tuple): 중심 좌표 (위도, 경도)
    - buildings_df (DataFrame): 건물 데이터를 포함하는 DataFrame
    - radius_km (float): 검색 반경 (킬로미터)
    
    Returns:
    - DataFrame: 필터링 및 정렬된 건물 데이터
    """
    # 거리 계산
    buildings_df['distance'] = buildings_df.apply(
        lambda row: geodesic(center_coord, (row['latitude'], row['longitude'])).km, axis=1)

    # 반경 내의 건물 필터링
    filtered_df = buildings_df[buildings_df['distance'] <= radius_km]

    # 거리 순으로 정렬
    sorted_df = filtered_df.sort_values('distance')

    return sorted_df

def print_buildings(buildings_df):
    """
    건물 데이터를 출력합니다.
    
    Parameters:
    - buildings_df (DataFrame): 건물 데이터를 포함하는 DataFrame
    """
    for index, row in buildings_df.iterrows():
        print(f"{row['name']} - Distance: {row['distance']:.2f} km")
    print(f"{len(buildings_df)}곳")
# 사용 예시
filepaths = ['school.csv', 'subway1.csv']  # CSV 파일 경로 (db 연결해서 사용해도 될것.)
center_coord = (37.536454060035, 126.89711732555)  # 중심 좌표 (이는 프론트 혹은 외부 서버 통해서 이용될것 같다.)
radius_km = 1  # 검색 반경 (킬로미터)

start_time = time.time()

for filepath in filepaths: # csv파일 돌면서
    file_start_time = time.time()

    buildings_df = load_building_data(filepath) # csv 파일 데이터 프레임화 시키고
    filtered_sorted_buildings = filter_and_sort_buildings(center_coord, buildings_df, radius_km) # 반경 1km이내 모든 건물들 뽑아서
    elapsed_time = time.time() - file_start_time
    print(f"{elapsed_time:.2f}초")
    print_buildings(filtered_sorted_buildings) ## 출력 (이부분은 아마 프론트 페이지 혹은 db에 저장 될수도 있다.)
    print('--------------------------') 

total_time = time.time() - start_time
print(f"총 실행시간: {total_time:.2f}초")