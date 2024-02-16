import mlflow
import os


def log_gsvc_to_mlflow(
    gscv, mlflow_experiment_name, application_number: str = "appli21"
):
    """Log a scikit-learn trained GridSearchCV object as an MLflow experiment."""
    # Set up MLFlow context
    mlflow.set_experiment(experiment_name=mlflow_experiment_name)

    for run_idx in range(len(gscv.cv_results_["params"])):
        # For each hyperparameter combination we trained the model with, we log a run in MLflow
        run_name = f"run {run_idx}"
        with mlflow.start_run(run_name=run_name):
            # Log hyperparameters
            params = gscv.cv_results_["params"][run_idx]
            for param in params:
                mlflow.log_param(param, params[param])

            # Log fit metrics
            scores = [
                score
                for score in gscv.cv_results_
                if "mean_test" in score or "std_test" in score
            ]
            for score in scores:
                mlflow.log_metric(score, gscv.cv_results_[score][run_idx])

            # Log model as an artifact
            mlflow.sklearn.log_model(gscv, "gscv_model")
            # Log training data URL
            mlflow.log_param("appli", application_number)
