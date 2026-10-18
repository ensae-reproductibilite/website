def build_pipeline(
    n_trees: int = 20,
    numeric_features=["Age", "Fare"],
    categorical_features=["Title", "Embarked", "Sex"]):
    """Random forest model for Titanic survival

    Args:
        n_trees (int, optional): _description_. Defaults to 20.

    Returns:
        _type_: _description_
    """

    numeric_transformer = Pipeline(
        steps=[
            ("imputer", SimpleImputer(strategy="median")),
            ("scaler", MinMaxScaler()),
        ]
    )

    categorical_transformer = Pipeline(
        steps=[
            ("imputer", SimpleImputer(strategy="most_frequent")),
            ("onehot", OneHotEncoder()),
        ]
    )

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

    pipe = Pipeline(
        [
            ("preprocessor", preprocessor),
            ("classifier", RandomForestClassifier(n_estimators=n_trees)),
        ]
    )

    return pipe
