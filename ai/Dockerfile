FROM python:3.11

WORKDIR /ai_model
COPY ./ai_model /ai_model

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]