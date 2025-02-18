from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import confusion_matrix

import pandas as pd
import numpy as np

# Définition des variables
numeric_features = ["Age", "Fare"]
categorical_features = ["Embarked", "Sex"]

# PREPROCESSING ----------------------------

# Handling missing values for numerical features
num_imputer = SimpleImputer(strategy="median")
X_train[numeric_features] = num_imputer.fit_transform(X_train[numeric_features])
X_test[numeric_features] = num_imputer.transform(X_test[numeric_features])

# Scaling numerical features
scaler = MinMaxScaler()
X_train[numeric_features] = scaler.fit_transform(X_train[numeric_features])
X_test[numeric_features] = scaler.transform(X_test[numeric_features])

# Handling missing values for categorical features
cat_imputer = SimpleImputer(strategy="most_frequent")
X_train[categorical_features] = cat_imputer.fit_transform(X_train[categorical_features])
X_test[categorical_features] = cat_imputer.transform(X_test[categorical_features])

# One-hot encoding categorical features
encoder = OneHotEncoder(handle_unknown='ignore', sparse_output=False)
X_train_encoded = encoder.fit_transform(X_train[categorical_features])
X_test_encoded = encoder.transform(X_test[categorical_features])

# Convert encoded features into a DataFrame
X_train_encoded = pd.DataFrame(X_train_encoded, columns=encoder.get_feature_names_out(categorical_features), index=X_train.index)
X_test_encoded = pd.DataFrame(X_test_encoded, columns=encoder.get_feature_names_out(categorical_features), index=X_test.index)

# Drop original categorical columns and concatenate encoded ones
X_train = X_train.drop(columns=categorical_features).join(X_train_encoded)
X_test = X_test.drop(columns=categorical_features).join(X_test_encoded)

# MODEL TRAINING ----------------------------

# Defining the model
model = RandomForestClassifier(n_estimators=n_trees)

# Fitting the model
model.fit(X_train, y_train)

# EVALUATION ----------------------------

# Scoring
rdmf_score = model.score(X_test, y_test)
print(f"{rdmf_score:.1%} de bonnes réponses sur les données de test pour validation")

# Confusion matrix
print(20 * "-")
print("matrice de confusion")
print(confusion_matrix(y_test, model.predict(X_test)))
