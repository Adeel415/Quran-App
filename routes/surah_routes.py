from fastapi import APIRouter
from services.quran_service import (
    get_surah,
    get_surah_translation,
    get_ayah_range
)

router = APIRouter()

# Full Surah (Arabic + Audio)
@router.get("/surah/{num}")
def surah(num: int):
    return get_surah(num)


# Translation Support
@router.get("/surah/{num}/translation")
def translation(num: int):
    return get_surah_translation(num)


# Range Control (IMPORTANT FOR YOU)
@router.get("/surah/{num}/{start}/{end}")
def range_ayah(num: int, start: int, end: int):
    return get_ayah_range(num, start, end)