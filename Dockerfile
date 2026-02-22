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

# 關鍵修改：使用 uvicorn 啟動
# server:mcp.app 的意思是：尋找 server.py 檔案裡的 mcp 物件的 app 屬性
CMD ["uvicorn", "server:mcp.app", "--host", "0.0.0.0", "--port", "8080"]
