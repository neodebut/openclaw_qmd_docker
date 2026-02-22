from mcp.server.fastmcp import FastMCP
from sentence_transformers import SentenceTransformer
import torch

# 初始化 FastMCP
mcp = FastMCP("BGE-M3-Memory-Server")

# 加載模型 (首次運行會自動下載)
device = "cuda" if torch.cuda.is_available() else "cpu"
model = SentenceTransformer('BAAI/bge-m3', device=device)

@mcp.tool()
async def generate_embedding(text: str) -> list[float]:
    """將文字轉換為 1024 維度的 BGE-M3 向量"""
    embedding = model.encode(text, normalize_embeddings=True)
    return embedding.tolist()

if __name__ == "__main__":
    # 使用 SSE 模式啟動，這才符合雲端部署需求
    mcp.run(transport="sse")
