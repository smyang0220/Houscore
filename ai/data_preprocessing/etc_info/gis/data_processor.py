import numpy as np
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
    center_lat, center_lon = center_coord
    latitudes = buildings_df['latitude'].values
    longitudes = buildings_df['longitude'].values

     # 거리 계산
    buildings_df['distance'] = haversine_np(center_lon, center_lat, longitudes, latitudes)

    # 반경 내의 건물 필터링
    filtered_df = buildings_df[buildings_df['distance'] <= radius_km]

    # 거리 순으로 정렬
    sorted_df = filtered_df.sort_values('distance')

    return sorted_df

def process_related_data(center_coord, df, radius_km):
    related_number = 0
    nearest_related = None
    filtered_data = filter_and_sort_buildings(center_coord, df, radius_km)
    related_number += len(filtered_data)
    if len(filtered_data) > 0:
        nearest_related = round(filtered_data.iloc[0]['distance'], 3)
    return related_number, nearest_related

def analyze_area_data(star_data, other_dfs):
    results = []
    start_time = time.time()

    for idx, row in star_data.iterrows():
        file_start_time = time.time()
        center_coord = (row['latitude'], row['longitude'])
        result = [process_related_data(center_coord, df, 2) for df in other_dfs]
        results.append([item for sublist in result for item in sublist])
        elapsed_time = time.time() - file_start_time
        print(f"Processed in {elapsed_time:.2f} seconds")

    star_data = append_results_to_dataframe(star_data, results)
    total_time = time.time() - start_time
    print(f"Total execution time: {total_time:.2f} seconds")
    return star_data

def append_results_to_dataframe(df, results):
    # 초중고 분리시
    categories = ['medical', 'subway', 'bus_stop', 'academy', 'laundry', 'market', 'park', 'library', 'kindergarden', 'elementary_school', 'middle_school', 'high_school', 'university']
    for i, cat in enumerate(categories):
        df[f'{cat}_related_number'] = [result[2*i] for result in results]
        df[f'nearest_{cat}_related'] = [result[2*i+1] if result[2*i+1] is not None else 2.1 for result in results]
    return df

