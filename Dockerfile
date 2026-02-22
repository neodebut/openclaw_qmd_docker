# 使用輕量化 Python 鏡像
FROM python:3.11-slim

# 設定工作目錄
WORKDIR /app

# 安裝基本系統套件
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# 複製依賴清單並安裝
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 重要：在構建階段就先下載模型，避免 Zeabur 啟動時因為下載太久而超時
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('BAAI/bge-m3')"

# 複製其餘程式碼
COPY . .

# 宣告對外埠號為 8080
EXPOSE 8080

# 設定環境變數，確保 Python 輸出日誌能即時顯示
ENV PYTHONUNBUFFERED=1

# 啟動命令
CMD ["python", "server.py"]
