import pandas as pd
import numpy as np
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler

# Définition des nouvelles données
new_data = pd.DataFrame({
    "Age": [25, np.nan, 40, 33, np.nan],
    "Fare": [10.50, 7.85, np.nan, 22.00, 12.75]
})

# Définition des transformations (même que dans le pipeline)
num_imputer = SimpleImputer(strategy="median")
scaler = MinMaxScaler()

# Apprentissage des transformations sur X_train (assumant que vous l'avez déjà)
X_train_numeric = X_train[["Age", "Fare"]]  # Supposons que X_train existe
num_imputer.fit(X_train_numeric)
scaler.fit(num_imputer.transform(X_train_numeric))

# Transformation des nouvelles données
new_data_imputed = num_imputer.transform(new_data)
new_data_scaled = scaler.transform(new_data_imputed)

# Création du DataFrame final
new_data_preprocessed = pd.DataFrame(
    new_data_scaled,
    columns=["Age_scaled", "Fare_scaled"]  # Générer des noms de colonnes adaptés
)

# Affichage du DataFrame
print(new_data_preprocessed)
