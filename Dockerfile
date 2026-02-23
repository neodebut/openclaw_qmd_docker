# 採用 OpenClaw 官方最新映像檔
FROM ghcr.io/openclaw/openclaw:latest

# 安裝所需系統依賴
RUN apt-get update && apt-get install -y curl unzip

# 安裝 Bun 運行環境
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# 全域安裝 qmd CLI 工具
RUN bun install -g https://github.com/tobi/qmd

# 確保工作目錄權限
WORKDIR /root/.openclaw

# 執行 OpenClaw 主程式
CMD ["openclaw", "start"]
