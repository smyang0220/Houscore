import pandas as pd

file_path = 'files/국토교통부_전국 버스정류장 위치정보_20231016.csv'
df = pd.read_csv(file_path, encoding='cp949')[['정류장번호', '정류장명', '위도', '경도']]

df.rename(columns={'정류장번호': 'bus_stop_no', '정류장명': 'bus_stop_name', '위도': 'latitude', '경도': 'longitude'}, inplace=True)
print(df)

df.to_csv('files/bus.csv', index=False)
