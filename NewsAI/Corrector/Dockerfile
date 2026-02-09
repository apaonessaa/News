FROM python:3.10-slim

ARG HF_TOKEN
ARG HF_MODEL
ARG HF_API

WORKDIR /app

COPY requirements.txt .
COPY main.py .

RUN python3 -m venv .venv
ENV PATH="/app/.venv/bin:$PATH"

RUN pip install -r requirements.txt

ENV HF_TOKEN=${HF_TOKEN}
ENV HF_MODEL=${HF_MODEL}
ENV HF_API=${HF_API}

EXPOSE 8000

ENTRYPOINT ["python3"]

CMD ["main.py"]
