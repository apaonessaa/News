FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
COPY main.py .
COPY download_models.py .

RUN python3 -m venv .venv
ENV PATH="/app/.venv/bin:$PATH"

# Download the model
RUN pip install -r requirements.txt
ENV MODEL_NAME=gsarti/it5-base-news-summarization
RUN python3 download_models.py

EXPOSE 8082

ENTRYPOINT ["python3"]

CMD ["main.py"]
