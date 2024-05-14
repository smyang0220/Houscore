import pandas as pd
from pyproj import Proj, transform
import openpyxl  # xlsx 파일을 저장하기 위해 필요

# xlsx 파일 로드
file_path = 'seoul_cinema.xlsx'  # 파일 경로를 여기에 입력하세요
df = pd.read_excel(file_path)

# 좌표계 정의
proj_2097 = Proj(init='epsg:2097')
proj_4326 = Proj(init='epsg:4326')

# 좌표 변환 함수
def convert_coords(x, y):
    try:
        # 공백이나 유효하지 않은 값 확인
        if pd.isnull(x) or pd.isnull(y):
            return None, None
        # 좌표 변환
        lon, lat = transform(proj_2097, proj_4326, x, y)
        return lon, lat
    except Exception as e:
        print(f"Error converting coordinates: {e}")
        return None, None

# 변환된 좌표를 저장할 새로운 열 추가
df[['lon', 'lat']] = df.apply(lambda row: convert_coords(row['좌표정보(X)'], row['좌표정보(Y)']), axis=1, result_type="expand")

# 결과를 새로운 xlsx 파일로 저장
output_path = 'seoul_cinema_converted_file.xlsx'  # 결과 파일 경로
df.to_excel(output_path, index=False)

print("좌표 변환 완료. 결과가 저장된 파일:", output_path)