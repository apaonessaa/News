FROM python:3.10-slim

ARG HF_TOKEN
ARG HF_MODEL

WORKDIR /app

COPY requirements.txt .
COPY main.py .

RUN python3 -m venv .venv
ENV PATH="/app/.venv/bin:$PATH"

RUN pip install -r requirements.txt

ENV HF_TOKEN=${HF_TOKEN}
ENV HF_API_URL=https://router.huggingface.co/hf-inference/models/${HF_MODEL}

EXPOSE 8083

ENTRYPOINT ["python3"]

CMD ["main.py"]
