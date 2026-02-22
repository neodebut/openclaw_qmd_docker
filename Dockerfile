FROM python:3.11-slim

WORKDIR /app

# 安裝系統依賴與 uvicorn
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# 確保 requirements.txt 裡有 uvicorn
RUN pip install --no-cache-dir -r requirements.txt uvicorn

# 預先下載模型
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('BAAI/bge-m3')"

COPY . .

# 宣告 8080 埠
EXPOSE 8080

# 修正後的啟動指令：指向 server.py 裡的 app 變數
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]
