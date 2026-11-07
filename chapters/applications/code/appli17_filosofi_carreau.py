# Extrait de src/data/import_data.py: constante extraite de add_filosofi_carreaux
# Filosofi columns we keep, raw name -> our name
FILOSOFI_COLUMNS = {
    "men": "nbre_menages",
    "men_pauv": "nbre_menages_pauvres",
    "men_prop": "nbre_menages_prop",
    "ind_snv": "somme_nv_vie",
    "log_soc": "nbre_logements_sociaux",
    "log_av45": "nbre_logements_avant_1945",
    "men_surf": "surface_totale_logements",
}


def get_filosofi_carreau(
    longitude: float,
    latitude: float,
    connection: duckdb.DuckDBPyConnection,
    url_filosofi: str,
) -> pd.DataFrame:
    """Return the Filosofi 200m cell containing a point, as a one-row DataFrame

    Used to describe a single address at prediction time: the same columns as
    add_filosofi_carreaux are returned, with NaN if the point lies in no cell.
    """
    connection.execute("INSTALL spatial")
    connection.execute("LOAD spatial")

    colonnes = ["idcar_200m", "ind", *FILOSOFI_COLUMNS]
    # The point is projected to EPSG:3035, the CRS of the cells, as in
    # add_filosofi_carreaux. The bbox column limits the rows read.
    filo = connection.sql(f"""
        WITH pt AS (
            SELECT ST_Transform(
                ST_Point({longitude}, {latitude}), 'EPSG:4326', 'EPSG:3035',
                always_xy := true
            ) AS p
        ),
        xy AS (SELECT ST_X(p) x, ST_Y(p) y, p FROM pt)
        SELECT {", ".join(colonnes)}
        FROM read_parquet('{url_filosofi}'), xy
        WHERE bbox.xmin <= x AND bbox.xmax >= x AND bbox.ymin <= y AND bbox.ymax >= y
        AND ST_Contains(geometry, p)
    """).to_df()

    if filo.empty:
        filo = pd.DataFrame([{col: np.nan for col in colonnes}])
    return filo.rename(columns=FILOSOFI_COLUMNS)
