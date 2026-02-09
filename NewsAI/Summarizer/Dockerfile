FROM python:3.10-slim

ARG HF_MODEL

WORKDIR /app

COPY requirements.txt .
COPY main.py .
COPY download_models.py .

RUN python3 -m venv .venv
ENV PATH="/app/.venv/bin:$PATH"

RUN pip install -r requirements.txt
ENV HF_MODEL=${HF_MODEL}
RUN python3 download_models.py

EXPOSE 8000

ENTRYPOINT ["python3"]

CMD ["main.py"]
