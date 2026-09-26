from dotenv import load_dotenv
load_dotenv()  # must run before any app module reads os.getenv(...)

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import societies, workers, services, bookings

app = FastAPI(title="GramSeva API", version="0.1.0")

# Loosen this before your national submission - fine for a local prototype demo
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(societies.router)
app.include_router(workers.router)
app.include_router(services.router)
app.include_router(bookings.router)


@app.get("/")
async def root():
    return {"status": "ok", "service": "GramSeva API"}
