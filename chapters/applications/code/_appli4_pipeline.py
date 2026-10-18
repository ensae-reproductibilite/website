import numpy as np
import pandas as pd
from lightgbm import LGBMRegressor
from sklearn.compose import ColumnTransformer, TransformedTargetRegressor
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import FunctionTransformer, OrdinalEncoder

train = pd.read_csv("train.csv", index_col=0, dtype={"code_commune": str})
test = pd.read_csv("test.csv", index_col=0, dtype={"code_commune": str})
X_train, y_train = train.drop("prix_m2", axis="columns"), train["prix_m2"]
X_test, y_test = test.drop("prix_m2", axis="columns"), test["prix_m2"]

n_trees = 1500

numeric_features = [
    "log_surface", "log_distance_eiffel", "nombre_pieces_principales",
    "nombre_lots", "log_surface_terrain", "ratio_carrez",
    "nbre_menages", "tx_pauvrete", "nv_vie_moyen",
    "part_proprietaires", "part_logements_sociaux",
    "part_logements_avant_1945", "surface_moyenne_logements",
    "NIVVIE_MEDIAN", "TAUX_PAUVRETE",
]
categorical_features = ["code_commune", "type_local"]


def as_category(df):
    """Convertit les colonnes en dtype 'category' pour LightGBM"""
    return df.astype("category")


# Variables numériques
numeric_transformer = Pipeline(
    steps=[
        ("imputer", SimpleImputer(strategy="median")),
    ]
)

# Variables catégorielles
categorical_transformer = Pipeline(
    steps=[
        ("imputer", SimpleImputer(strategy="most_frequent")),
        (
            "ordinal",
            OrdinalEncoder(handle_unknown="use_encoded_value", unknown_value=-1),
        ),
        ("as_category", FunctionTransformer(as_category)),
    ]
)

# Preprocessing
preprocessor = ColumnTransformer(
    transformers=[
        ("Preprocessing numerical", numeric_transformer, numeric_features),
        ("Preprocessing categorical", categorical_transformer, categorical_features),
    ]
).set_output(transform="pandas")

# Pipeline
pipe_lgbm = Pipeline(
    [
        ("preprocessor", preprocessor),
        (
            "regressor",
            LGBMRegressor(
                n_estimators=n_trees,
                learning_rate=0.03,
                num_leaves=31,
                min_child_samples=10,
                subsample=0.8,
                colsample_bytree=0.8,
                random_state=0,
                verbose=-1,
            ),
        ),
    ]
)

# Apprentissage sur log(1 + prix), prédiction remise en €/m²
pipe = TransformedTargetRegressor(
    regressor=pipe_lgbm, func=np.log1p, inverse_func=np.expm1
)

pipe.fit(X_train, y_train)
