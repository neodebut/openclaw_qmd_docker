import os
from mcp.server.fastmcp import FastMCP
from sentence_transformers import SentenceTransformer
import torch

# 1. 初始化 FastMCP
mcp = FastMCP("BGE-M3-Memory-Server")

# --- 這裡是你原本的工具定義 ---
@mcp.tool()
async def generate_embedding(text: str) -> list[float]:
    # ... 原本的程式碼 ...
    pass

# 2. 【關鍵修正】將內部的 ASGI app 賦值給一個全域變數
app = mcp.app
