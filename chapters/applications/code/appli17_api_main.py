"""
API estimating the price per m² of a property from its address

Lancer l'API depuis le dossier du projet, après avoir entraîné le modèle
avec `uv run train.py` :

    uv run uvicorn app.api:app
"""

import os

import duckdb
import skops.io as sio
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException

from src.models.predict import build_inference_features, predict_prix_m2

load_dotenv()
JETON_API = os.environ.get("JETON_API", "")

URL_RAW = "https://minio.lab.sspcloud.fr/lgaliana/ensae-reproductibilite/data/raw"
URL_FILOSOFI = f"{URL_RAW}/filosofi_carreaux_200m_2021.parquet"

con = duckdb.connect(database=":memory:")

# The model is saved by train.py. skops refuses to load unknown types by
# default: we list them and accept them explicitly, since we trained the model.
unknown_types = sio.get_untrusted_types(file="model.skops")
model = sio.load("model.skops", trusted=unknown_types)

app = FastAPI(
    title="Prix au m² en petite couronne",
    description=(
        "Estimation du prix au m² des logements à Paris et dans les départements "
        "92, 93 et 94, à partir des transactions DVF enrichies par des données "
        "socio-économiques Filosofi."
    ),
)


@app.get("/")
def accueil():
    """Présentation de l'API"""
    return {
        "Message": "Bienvenue sur l'API d'estimation du prix au m²",
        "Model_name": "Prix au m² DVF (LightGBM)",
        "Model_version": "0.1",
    }


@app.get("/predict")
def predire(
    adresse: str = "20 avenue de Ségur 75007 Paris",
    type_local: str = "Appartement",
    surface: float = 45.0,
    nombre_pieces: int = 2,
):
    """Estimer le prix d'un logement à partir de son adresse

    - `type_local` : `Appartement` ou `Maison`
    - `surface` : surface réelle du bâti, en m²
    - `nombre_pieces` : nombre de pièces principales

    Seules les adresses de Paris et des départements 92, 93 et 94 sont acceptées.
    """
    try:
        features = build_inference_features(
            adresse=adresse,
            type_local=type_local,
            surface_reelle_bati=surface,
            nombre_pieces_principales=nombre_pieces,
            connection=con,
            url_filosofi=URL_FILOSOFI,
            jeton_api=JETON_API,
        )
    except ValueError as erreur:
        raise HTTPException(status_code=400, detail=str(erreur))

    prix_m2 = predict_prix_m2(model, features)
    return {
        "adresse": features.loc[0, "label"],
        "code_commune": features.loc[0, "code_commune"],
        "prix_m2": round(prix_m2),
        "prix_estime": round(prix_m2 * surface),
    }
