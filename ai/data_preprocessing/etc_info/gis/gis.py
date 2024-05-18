from data_loader import load_excel_data, load_csv_data, load_and_prepare_hospitals
from data_processor import analyze_area_data
import pandas as pd
import time

def main():
    now_time = time.time()
    # 파일 경로 설정
    starfile = 'updated_check_data_240513.xlsx'
    star_data = load_excel_data(starfile)
    safefile = 'safe_area_rank.csv'
    safedata = load_csv_data(safefile)
    
    # # area 컬럼과 plat_plc 컬럼을 기반으로 crime_rank 추가
    def get_crime_rank(row, area_data, safe_data):
        for area in area_data:
            if area in row['plat_plc']:  # 이 부분은 이미 문자열 포함 여부를 확인하므로 str.contains()가 필요 없음
                matched_area_data = safe_data[safedata['area'] == area]
                if not matched_area_data.empty:
                    return matched_area_data['crime_rank'].iloc[0]
        return None
    

    area_data = safedata['area'].unique()
    star_data['crime_rank'] = star_data.apply(lambda row: get_crime_rank(row, area_data, safedata), axis=1)

    hospitalpaths = 'hospital.csv'
    other_files = [
        'subway.csv', 'bus3.csv', 'academy.csv', 'laundry.csv', 'store.csv','park.csv',
        'library.csv','school.csv'
    ]
    hospitals_df = load_and_prepare_hospitals(hospitalpaths)
    other_dfs = [load_csv_data(f) for f in other_files]


    # 데이터 분석
    updated_star_data = analyze_area_data(star_data, [hospitals_df] + other_dfs)
    updated_star_data.to_excel('updated_starpoint(대중교통통합)(20240516)2km.xlsx', index=False)
    updated_star_data.to_csv('updated_starpoint(대중교통통합)(20240516)2km.csv', index=False)
    updated_star_data.to_csv('updated_starpoint(대중교통통합)(cp949)(20240516)2km.csv', index=False, encoding='cp949')
    done_time = time.time() - now_time
    print(f"Total execution time: {done_time:.2f} seconds")

if __name__ == '__main__':
    main()