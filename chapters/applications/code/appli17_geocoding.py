"""
Geocoding functions: from a postal address to coordinates
"""

import requests

URL_BAN = "https://data.geopf.fr/geocodage/search"


def geocode_address(adresse: str) -> dict:
    """Turn a postal address into coordinates and administrative codes

    Uses the Base Adresse Nationale (BAN) geocoder. For Paris, citycode is the
    arrondissement code (75107 for the 7th), as in DVF.
    """
    response = requests.get(URL_BAN, params={"q": adresse, "limit": 1}, timeout=10)
    response.raise_for_status()
    features = response.json()["features"]

    if not features:
        raise ValueError(f"Adresse introuvable : {adresse}")

    feature = features[0]
    longitude, latitude = feature["geometry"]["coordinates"]
    return {
        "label": feature["properties"]["label"],
        "score": feature["properties"]["score"],
        "longitude": longitude,
        "latitude": latitude,
        "code_commune": feature["properties"]["citycode"],
        "code_departement": feature["properties"]["depcode"],
    }
