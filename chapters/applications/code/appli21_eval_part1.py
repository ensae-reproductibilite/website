import pandas as pd
from sklearn.metrics import confusion_matrix, accuracy_score
from joblib import load

# EVALUATE ----------------------------

loaded_model = load("model.joblib")

# Predict on a Pandas DataFrame.
X_test = pd.read_csv("data/intermediate/X_test.csv")
y_test = pd.read_csv("data/intermediate/y_test.csv")
y_test_predict = loaded_model.predict(X_test)

# EVALUATE ----------------------------

matrix = confusion_matrix(y_test, y_test_predict)

print("Accuracy:")
print(f"{accuracy_score(y_test, y_test_predict):.0%}")
print("Matrice de confusion:")
print(matrix)

