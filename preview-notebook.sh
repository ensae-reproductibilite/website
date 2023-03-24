NOTEBOOK_NAME="titanic"
# ex: polars-tuto

WORK_DIR="/home/onyxia/work"
CLONE_DIR="${WORK_DIR}/repo-git"

COURSE_DIR="${CLONE_DIR}/content/notebooks"

# Clone course repository
REPO_URL="https://github.com/linogaliana/ensae-reproductibilite-application.git"
git clone --depth 1 $REPO_URL $CLONE_DIR

# Put relevant notebook in formation dir
cp "${COURSE_DIR}/${NOTEBOOK_NAME}.ipynb" "${WORK_DIR}"

# Remove useless repositories
rm -rf $CLONE_DIR ${WORK_DIR}/lost+found

# Open the relevant notebook when starting Jupyter Lab
jupyter server --generate-config
echo "c.LabApp.default_url = '/lab/tree/${NOTEBOOK_NAME}.ipynb'" >> /home/onyxia/.jupyter/jupyter_server_config.py