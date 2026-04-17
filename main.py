from fastapi import FastAPI
from routes.surah_routes import router as surah_router
from routes.search_routes import router as search_router

app = FastAPI(title="Quran API", version="1.0")

app.include_router(surah_router)
app.include_router(search_router)


@app.get("/")
def home():
    return {
        "message": "Quran API Running",
        "endpoints": [
            "/surah/{id}",
            "/surah/{id}/translation",
            "/surah/{id}/{start}/{end}",
            "/search?query=Allah"
        ]
    }
    