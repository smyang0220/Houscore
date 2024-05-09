import pandas as pd

def load_excel_data(file_path):
    return pd.read_excel(file_path)

def load_csv_data(file_path):
    try:
        return pd.read_csv(file_path, encoding='utf-8')
    except UnicodeDecodeError:
        return pd.read_csv(file_path, encoding='cp949')


def load_and_prepare_hospitals(file_path):
    df = load_csv_data(file_path)
    df = df[['hospital_name', 'latitude', 'longitude']].drop_duplicates(subset='hospital_name')
    return df[['latitude', 'longitude']]    