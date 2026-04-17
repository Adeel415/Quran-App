import requests

BASE_URL = "https://api.alquran.cloud/v1"

def get_surah(surah_number, edition="ar.alafasy"):
    url = f"{BASE_URL}/surah/{surah_number}/{edition}"
    return requests.get(url).json()


def get_surah_translation(surah_number, lang="en.sahih"):
    url = f"{BASE_URL}/surah/{surah_number}/{lang}"
    return requests.get(url).json()


def get_ayah_range(surah_number, start, end):
    data = get_surah(surah_number)
    ayahs = data["data"]["ayahs"][start-1:end]

    return {
        "surah": data["data"]["englishName"],
        "ayahs": ayahs
    }