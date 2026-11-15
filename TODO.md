# À faire pour la v5

Repris de l'issue [#44](https://github.com/ensae-reproductibilite/website/issues/44).

## Évolutions globales rendues nécessaires par l'influence croissante de l'IA

- [ ] Intérêt de conserver la revue de code ? Elles sont pour l'essentiel générées
- [ ] Passage à une évaluation sur soutenance pour avoir une explication du projet, des choix d'archi, etc. ?
- [ ] Idée : proposer deux modes, avec et sans IA, avec des attendus différenciés sur les projets selon le mode choisi

## Cours

- [ ] Env virtuels : uv à la place de venv / conda
- [ ] Rédiger le chapitre déploiement

## Application

- [x] Simplifier l'image Docker pour les applications suivant la première Docker : partir de l'image python3 ou même astral/uv plutôt que d'un ubuntu
- [ ] Modifier le script checkpoint (checkout branch + nouvelle branche dérivée + retirer les branches trigger des CI). À vérifier : que `git push` ne pousse pas toutes les branches à chaque fois, ce qui déclencherait plusieurs CI
- [ ] Lister à chaque checkpoint toutes les modifs à appliquer (bucket S3, compte DockerHub...)
- [x] Utiliser les GitHub Codespaces à la place de Play with Docker : env VSCode avec Docker pré-installé
- [x] Réfléchir à une meilleure appli pour le fil rouge : remplacer Titanic (un modèle de ML à partir du recensement ? Possibilité de travailler sur une région puis toute la France pour le chapitre données volumineuses avec DuckDB)
- [ ] Lorsqu'on sépare l'entraînement du modèle du `main.py`, mettre le binaire du modèle entraîné sur S3 pour complètement découpler l'entraînement de l'API
- [ ] Appli (optionnelle ?) sur Vault via le SSP Cloud
- [x] Idée d'API à croiser avec les données pour utiliser un vrai jeton d'API
- [ ] Harmoniser les noms des différentes ressources Kube en `dvf-xxx` pour que la DIIT puisse les nettoyer en batch à la fin (normalement déjà le cas sur deployment/service/ingress mais à vérifier, à faire pour ArgoCD)
- [ ] Présenter les charts Helm pour packager les ressources Kubernetes
- [x] Plutôt qu'un CI avec les tests de linting, recommander des tests a priori (pre-commit hooks)
- [ ] Montrer l'intégration de ruff directement dans les tools du `pyproject.toml`
