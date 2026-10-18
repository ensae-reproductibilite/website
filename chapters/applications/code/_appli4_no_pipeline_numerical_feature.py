import pandas as pd
from sklearn.impute import SimpleImputer

# Définition des transformations (même que dans le pipeline)
num_imputer = SimpleImputer(strategy="median")

# Apprentissage des transformations sur X_train (assumant que vous l'avez déjà)
X_train_numeric = X_train[numeric_features]  # Supposons que X_train existe
num_imputer.fit(X_train_numeric)

# Transformation des nouvelles données
new_data_imputed = num_imputer.transform(new_data[numeric_features])

# Création du DataFrame final
new_data_preprocessed = pd.DataFrame(
    new_data_imputed,
    columns=numeric_features,  # Retrouver soi-même les noms des colonnes
    index=new_data.index,
)

# Affichage du DataFrame
print(new_data_preprocessed)
