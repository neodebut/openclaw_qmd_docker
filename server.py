import os
from mcp.server.fastmcp import FastMCP
from sentence_transformers import SentenceTransformer
import torch

# 初始化 FastMCP
mcp = FastMCP("BGE-M3-Memory-Server")

# 加載模型 (優先檢查有無 GPU)
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Loading BGE-M3 model on {device}...")
model = SentenceTransformer('BAAI/bge-m3', device=device)

@mcp.tool()
async def generate_embedding(text: str) -> list[float]:
    """將文字轉換為 1024 維度的 BGE-M3 向量"""
    embedding = model.encode(text, normalize_embeddings=True)
    return embedding.tolist()

if __name__ == "__main__":
    # 取得 Zeabur 可能提供的 PORT 環境變數，若無則預設為 8080
    port = int(os.environ.get("PORT", 8080))
    
    print(f"🚀 Starting MCP Server on port {port}...")
    
    # 執行伺服器，並明確綁定 0.0.0.0 與 8080
    mcp.run(
        transport="sse",
        host="0.0.0.0", 
        port=port
    )
