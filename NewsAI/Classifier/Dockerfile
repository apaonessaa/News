# -- Build ---
FROM python:3.10-slim

ARG HF_TOKEN
ARG HF_API

WORKDIR /app

COPY requirements.txt .
COPY main.py .

RUN python3 -m venv .venv
ENV PATH="/app/.venv/bin:$PATH"

RUN pip install -r requirements.txt

ENV HF_TOKEN=${HF_TOKEN}
ENV HF_API=${HF_API}

# --- WSGI ---
RUN pip install gunicorn==25.1.0

EXPOSE 8000

CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "main:app"]
