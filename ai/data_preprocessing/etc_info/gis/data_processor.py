import numpy as np
import pandas as pd
import time

def haversine_np(lon1, lat1, lon2, lat2):
    """
    Haversine 공식을 이용해 지구 상의 두 점 사이의 거리를 계산합니다.
    입력은 모두 라디안 단위로 변환됩니다.
    """

    lon1, lat1, lon2, lat2 = map(np.radians, [lon1, lat1, lon2, lat2])
    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = np.sin(dlat/2.0)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon/2.0)**2
    c = 2 * np.arcsin(np.sqrt(a))
    km = 6371 * c  # 지구 반지름을 킬로미터 단위로 환산
    return km

def filter_and_sort_buildings(center_coard, buildings_df, radius_km):
    """
    주어진 반경 내의 건물들을 필터링하고 거리 순으로 정렬합니다.
    
    Parameters:
    - center_coord (tuple): 중심 좌표 (위도, 경도)
    - buildings_df (DataFrame): 건물 데이터를 포함하는 DataFrame
    - radius_km (float): 검색 반경 (킬로미터)
    
    Returns:
    - DataFrame: 필터링 및 정렬된 건물 데이터
    """
    center_lat, center_lon = center_coard
    latitudes = buildings_df['latitude'].values
    longitudes = buildings_df['longitude'].values

    # 모든 건물에 대해 거리 계산
    buildings_df['distance'] = haversine_np(center_lon, center_lat, longitudes, latitudes)

    # 반경 2km 이내의 건물 필터링
    filtered_df = buildings_df[buildings_df['distance'] <= radius_km]

    # 가장 가까운 건물 찾기
    nearest_related = filtered_df['distance'].min()

    return nearest_related

def process_related_data(center_coard, df, radius_km):
    nearest_distance = filter_and_sort_buildings(center_coard, df, radius_km)
    nearest_related = round(nearest_distance, 3) if nearest_distance is not None else None
    return nearest_related


def analyze_area_data(star_data, other_dfs):
    results = []
    start_time = time.time()

    for idx, row in star_data.iterrows():
        file_start_time = time.time()
        if pd.notna(row['latitude']) and pd.notna(row['longitude']):
            center_coard = (row['latitude'], row['longitude'])
            result = [process_related_data(center_coard, df, 1) for df in other_dfs]
            results.append(result)
        else:
            # 위도 또는 경도가 결측인 경우, 결과에 None 또는 적절한 기본값을 추가합니다.
            results.append([None] * (len(other_dfs) * 2))  # 각 df에 대해 related_number와 nearest_related를 None으로 설정
        elapsed_time = time.time() - file_start_time
        print(f"Processed in {elapsed_time:.2f} seconds")

    star_data = append_results_to_dataframe(star_data, results)
    total_time = time.time() - start_time
    print(f"Total execution time: {total_time:.2f} seconds")
    return star_data

def append_results_to_dataframe(df, results):
    # 초중고 분리시
    categories = ['medical', 'subway', 'bus_stop', 'academy', 'laundry', 'market', 'park', 'library', 'school']
    for i, cat in enumerate(categories):
        df[f'nearest_{cat}_related'] = [1 if len(result) <= 2*i+1 or not result else result[2*i+1] for result in results]
    # Creating the 'nearest_transit_related' column using minimum of the two related columns
    df['nearest_transit_related'] = df[['nearest_subway_related', 'nearest_bus_stop_related']].min(axis=1)

    # Dropping the old columns
    df.drop(columns=['nearest_subway_related', 'nearest_bus_stop_related'], inplace=True)

    return df

