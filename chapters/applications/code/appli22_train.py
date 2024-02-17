"""
Prediction de la survie d'un individu sur le Titanic
"""

# GESTION ENVIRONNEMENT --------------------------------

from pathlib import Path
import argparse
from joblib import dump
from sklearn.model_selection import GridSearchCV

import src.data.import_data as imp
import src.features.build_features as bf
import src.models.log as mlog
import src.models.train_evaluate as te


# PARAMETRES -------------------------------

# Paramètres ligne de commande
parser = argparse.ArgumentParser(description="Paramètres du random forest")
parser.add_argument("--n_trees", type=int, default=20, help="Nombre d'arbres")
parser.add_argument("--appli", type=str, default="appli21", help="Application number")
args = parser.parse_args()

# Paramètres YAML
config = imp.import_yaml_config("configuration/config.yaml")
base_url = (
    "https://minio.lab.sspcloud.fr/projet-formation/ensae-reproductibilite/data/raw"
)
API_TOKEN = config.get("jeton_api")
LOCATION_TRAIN = config.get("train_path", f"{base_url}/train.csv")
LOCATION_TEST = config.get("test_path", f"{base_url}/test.csv")
TEST_FRACTION = config.get("test_fraction", 0.1)
N_TREES = args.n_trees
APPLI_ID = args.appli
EXPERIMENT_NAME = "titanicml"

# FEATURE ENGINEERING --------------------------------

titanic_raw = imp.import_data(LOCATION_TRAIN)

# Create a 'Title' variable
titanic_intermediate = bf.feature_engineering(titanic_raw)


train, test = te.split_train_test_titanic(
    titanic_intermediate, fraction_test=TEST_FRACTION
)
X_train, y_train = train.drop("Survived", axis="columns"), train["Survived"]
X_test, y_test = test.drop("Survived", axis="columns"), test["Survived"]


def log_local_data(data, filename):
    data.to_csv(f"data/intermediate/{filename}.csv", index=False)


output_dir = Path("data/intermediate")
output_dir.mkdir(parents=True, exist_ok=True)

log_local_data(X_train, "X_train")
log_local_data(X_test, "X_test")
log_local_data(y_train, "y_train")
log_local_data(y_test, "y_test")


# MODELISATION: RANDOM FOREST ----------------------------

pipe = te.build_pipeline(n_trees=N_TREES, categorical_features=["Embarked", "Sex"])

param_grid = {
    "classifier__n_estimators": [10, 20, 50],
    "classifier__max_leaf_nodes": [5, 10, 50],
}


pipe_cross_validation = GridSearchCV(
    pipe,
    param_grid=param_grid,
    scoring=["accuracy", "precision", "recall", "f1"],
    refit="f1",
    cv=5,
    n_jobs=5,
    verbose=1,
)

pipe_cross_validation.fit(X_train, y_train)

mlog.log_gsvc_to_mlflow(pipe_cross_validation, EXPERIMENT_NAME, APPLI_ID)

pipe = pipe_cross_validation.best_estimator_

dump(pipe, "model.joblib")
