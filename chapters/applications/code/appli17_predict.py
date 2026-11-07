"""
Prediction functions: from an address to a price per m²
"""

import duckdb
import geopandas as gpd

from src.data.build_features import (
    add_distance_eiffel,
    add_filosofi_ratios,
    add_surface_features,
)
from src.data.geocoding import geocode_address
from src.data.import_data import get_filosofi_carreau, get_melodi_indicator

DEPARTEMENTS_MODELE = ["75", "92", "93", "94"]


def build_inference_features(
    adresse: str,
    type_local: str,
    surface_reelle_bati: float,
    nombre_pieces_principales: int,
    connection: duckdb.DuckDBPyConnection,
    url_filosofi: str,
    jeton_api: str,
    nombre_lots: int = 1,
    surface_terrain: float = 0.0,
    lot1_surface_carrez: float | None = None,
) -> gpd.GeoDataFrame:
    """Build the model features of one property from its address

    The features are computed by the same functions as in training
    (add_filosofi_ratios, add_surface_features, add_distance_eiffel), so that
    training and serving see the same variables. build_features is not used:
    it computes the target and filters outliers, which make no sense here.
    """
    localisation = geocode_address(adresse)
    if localisation["code_departement"] not in DEPARTEMENTS_MODELE:
        raise ValueError(
            "Le modèle ne couvre que Paris et la petite couronne "
            f"(92, 93, 94) : {localisation['label']}"
        )

    code_commune = localisation["code_commune"]
    logement = gpd.GeoDataFrame(
        {
            "label": [localisation["label"]],
            "code_commune": [code_commune],
            "type_local": [type_local],
            "surface_reelle_bati": [surface_reelle_bati],
            "nombre_pieces_principales": [nombre_pieces_principales],
            "nombre_lots": [nombre_lots],
            "surface_terrain": [surface_terrain],
            "lot1_surface_carrez": [lot1_surface_carrez],
        },
        geometry=gpd.points_from_xy(
            [localisation["longitude"]], [localisation["latitude"]]
        ),
        crs="EPSG:4326",
    )
    logement["lot1_surface_carrez"] = logement["lot1_surface_carrez"].astype(float)

    # Filosofi cell of the address
    cellule = get_filosofi_carreau(
        localisation["longitude"], localisation["latitude"], connection, url_filosofi
    )
    logement = logement.join(cellule)

    # Commune indicators: Paris is split into arrondissements (ARM) in Melodi,
    # the other municipalities are COM
    niveau = "ARM" if code_commune.startswith("75") else "COM"
    geo_level = (f"{niveau}-{code_commune}",)
    for code, nom_indicateur in [
        ("MED_SL", "NIVVIE_MEDIAN"),
        ("PR_MD60", "TAUX_PAUVRETE"),
    ]:
        indicateur = get_melodi_indicator(
            code=code,
            value_name=nom_indicateur,
            jeton_api=jeton_api,
            geo_level=geo_level,
        )
        logement = logement.merge(
            indicateur, left_on="code_commune", right_on="CODGEO", how="left"
        ).drop(columns="CODGEO")

    logement = add_filosofi_ratios(logement)
    logement = add_surface_features(logement)
    return add_distance_eiffel(logement)


def predict_prix_m2(model, features: gpd.GeoDataFrame) -> float:
    """Predict the price per m² of the property described by features"""
    return float(model.predict(features)[0])
