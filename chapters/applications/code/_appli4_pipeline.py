import pandas as pd
from sklearn.preprocessing import OneHotEncoder, MinMaxScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer

train = pd.read_csv("train.csv")
test = pd.read_csv("test.csv")
X_train, y_train = train.drop("Survived", axis="columns"), train["Survived"]
X_test, y_test = test.drop("Survived", axis="columns"), train["Survived"]

MAX_DEPTH = None
MAX_FEATURES = "sqrt"
n_trees=20

numeric_features = ["Age", "Fare"]
categorical_features = ["Embarked", "Sex"]

# Variables numériques
numeric_transformer = Pipeline(
    steps=[
        ("imputer", SimpleImputer(strategy="median")),
        ("scaler", MinMaxScaler()),
    ]
)

# Variables catégorielles
categorical_transformer = Pipeline(
    steps=[
        ("imputer", SimpleImputer(strategy="most_frequent")),
        ("onehot", OneHotEncoder()),
    ]
)

# Preprocessing
preprocessor = ColumnTransformer(
    transformers=[
        ("Preprocessing numerical", numeric_transformer, numeric_features),
        (
            "Preprocessing categorical",
            categorical_transformer,
            categorical_features,
        ),
    ]
)

# Pipeline
pipe = Pipeline(
    [
        ("preprocessor", preprocessor),
        ("classifier", RandomForestClassifier(
            n_estimators=n_trees,
            max_depth=MAX_DEPTH,
            max_features=MAX_FEATURES
        )),
    ]
)

pipe.fit(X_train, y_train)
