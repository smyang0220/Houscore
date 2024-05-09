from data_loader import load_excel_data, load_csv_data, load_and_prepare_hospitals
from data_processor import analyze_area_data
def main():
    # 파일 경로 설정
    starfile = 'final_merged_check_dataset.xlsx'
    # 중복된 좌표가 있는 병원
    hospitalpaths = 'labeled_hospital_info.csv'
    other_files = [
        'subway1.csv', 'bus.csv', 'academy.csv', 'laundry.csv', 'market.csv','park.csv',
        'public_library.csv','kindergarden.csv','elementaryschool.csv', 'middleschool.csv', 'highschool.csv', 'university.csv'
    ]

    # 데이터 로드
    star_data = load_excel_data(starfile)
    # 중복된 좌표가 있는 병원
    hospitals_df = load_and_prepare_hospitals(hospitalpaths)
    other_dfs = [load_csv_data(f) for f in other_files]

    # 데이터 분석
    updated_star_data = analyze_area_data(star_data, [hospitals_df] + other_dfs)
    updated_star_data.to_excel('updated_starpoint(학교분리)(20240505)2km.xlsx', index=False)
    updated_star_data.to_csv('updated_starpoint(학교분리)(20240505)2km.csv', index=False)
    updated_star_data.to_csv('updated_starpoint(학교분리)(cp949)(20240505)2km.csv', index=False, encoding='cp949')
    

if __name__ == '__main__':
    main()