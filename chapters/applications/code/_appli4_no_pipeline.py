from lightgbm import LGBMRegressor
from sklearn.impute import SimpleImputer
from sklearn.metrics import root_mean_squared_error
from sklearn.preprocessing import OrdinalEncoder

import numpy as np

# Définition des variables
numeric_features = [
    "log_surface", "log_distance_eiffel", "nombre_pieces_principales",
    "nombre_lots", "log_surface_terrain", "ratio_carrez",
    "nbre_menages", "tx_pauvrete", "nv_vie_moyen",
    "part_proprietaires", "part_logements_sociaux",
    "part_logements_avant_1945", "surface_moyenne_logements",
    "NIVVIE_MEDIAN", "TAUX_PAUVRETE",
]
categorical_features = ["code_commune", "type_local"]
features = numeric_features + categorical_features

X_train = X_train[features].copy()
X_test = X_test[features].copy()

# PREPROCESSING ----------------------------

# Handling missing values for numerical features
num_imputer = SimpleImputer(strategy="median")
X_train[numeric_features] = num_imputer.fit_transform(X_train[numeric_features])
X_test[numeric_features] = num_imputer.transform(X_test[numeric_features])

# Handling missing values for categorical features
cat_imputer = SimpleImputer(strategy="most_frequent")
X_train[categorical_features] = cat_imputer.fit_transform(X_train[categorical_features])
X_test[categorical_features] = cat_imputer.transform(X_test[categorical_features])

# Ordinal encoding categorical features (unknown categories in test -> -1)
encoder = OrdinalEncoder(handle_unknown="use_encoded_value", unknown_value=-1)
X_train[categorical_features] = encoder.fit_transform(X_train[categorical_features])
X_test[categorical_features] = encoder.transform(X_test[categorical_features])

# LightGBM recognizes categorical variables through the 'category' dtype
X_train[categorical_features] = X_train[categorical_features].astype("category")
X_test[categorical_features] = X_test[categorical_features].astype("category")

# Log transformation of the target (do not forget to invert it after prediction!)
y_train_log = np.log1p(y_train)

# MODEL TRAINING ----------------------------

# Defining the model
model = LGBMRegressor(
    n_estimators=n_trees,
    learning_rate=0.03,
    num_leaves=31,
    min_child_samples=10,
    subsample=0.8,
    colsample_bytree=0.8,
    random_state=0,
    verbose=-1,
)

# Fitting the model
model.fit(X_train, y_train_log)

# EVALUATION ----------------------------

# Back to €/m² before computing the error
y_pred = np.expm1(model.predict(X_test))
rmse_test = root_mean_squared_error(y_test, y_pred)
print(f"RMSE sur le test : {rmse_test:,.0f} €/m²")
