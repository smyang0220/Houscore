## 지오코드 처리 과정.

1. csv,xlsx 파일에 위경도 값이 epsg:4326 으로 존재하는 경우.
    - 해당 컬럼명을 위경도 좌표 범위에 맞게 latitude, longitude로 변경.
2. csv,xlsx 파일에 위경도 값이 epsg:4326 이 아닌 다른 좌표값으로 존재하는 경우.

    `pip install pyproj`

    - chat gpt를 통해 해당 컬럼에 등록된 위경도값의 형식을 받는다.
    - pyproj 패키지를 이용하여 gpt를 통해 얻은 위경도 값의 형식을 epsg:4326으로 변경.

    ```
    def convert_coords(x, y):
        try:
            # 공백이나 유효하지 않은 값 확인
            if pd.isnull(x) or pd.isnull(y):
                return None, None
            # 좌표 변환
            lon, lat = transform(proj_2097, proj_4326, x , y)
            return lon, lat
        except Exception as e:
            print(f"Error converting coordinates: {e}")
            return None, None # 좌표 변환 함수
    ```

    - 해당 컬럼명을 latitude, longitude로 변경.

3. csv,xlsx 파일에 위경도 값이 존재 하지 않으며 주소만 있을 경우.
    - OPEN_API https://www.vworld.kr/dev/v4api.do 를 통해서 OPEN_API신청.
    - 해당 과정에서 나오지 않았을 경우 수작업으로 위, 경도 좌표값을 찾아야 한다.
