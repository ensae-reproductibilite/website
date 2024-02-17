def feature_engineering(data: pd.DataFrame) -> pd.DataFrame:
    """Applying our feature engineering pipeline

    Args:
        data (pd.DataFrame): Initial dataframe

    Returns:
        pd.DataFrame: Dataframe with feature engineering being handled
    """
    data_training = create_variable_title(data)
    data_training = check_has_cabin(data_training)
    data_training = ticket_length(data_training)
    return data_training
