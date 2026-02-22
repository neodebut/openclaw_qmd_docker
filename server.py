import os
from mcp.server.fastmcp import FastMCP
from sentence_transformers import SentenceTransformer
import torch

# 初始化 FastMCP 實例
mcp = FastMCP("BGE-M3-Memory-Server")

# 加載模型
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Loading BGE-M3 model on {device}...")
model = SentenceTransformer('BAAI/bge-m3', device=device)

@mcp.tool()
async def generate_embedding(text: str) -> list[float]:
    """將文字轉換為 1024 維度的 BGE-M3 向量"""
    embedding = model.encode(text, normalize_embeddings=True)
    return embedding.tolist()

# 注意：這裡不要寫 if __name__ == "__main__": mcp.run(...)
# 因為我們改用 uvicorn 來啟動 mcp.app
