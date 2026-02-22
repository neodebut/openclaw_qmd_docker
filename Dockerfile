FROM python:3.11-slim

WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# 複製並安裝 Python 套件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 預先下載模型（避免 Zeabur 啟動超時）
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('BAAI/bge-m3')"

COPY . .

# 暴露 MCP SSE 端口 (預設為 8080)
EXPOSE 8080

# 啟動伺服器
CMD ["python", "server.py"]
