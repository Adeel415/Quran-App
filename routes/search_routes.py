from fastapi import APIRouter
import requests

router = APIRouter()

@router.get("/search")
def search(query: str):
    url = f"https://api.alquran.cloud/v1/search/{query}/all/en"
    return requests.get(url).json()