#!/bin/bash

code-server --install-extension yzhang.markdown-all-in-one
code-server --install-extension oderwat.indent-rainbow
code-server --install-extension tamasfe.even-better-toml
code-server --install-extension aaron-bond.better-comments
code-server --install-extension github.vscode-github-actions


# Replace default flake8 linter with project-preconfigured ruff
code-server --uninstall-extension ms-python.flake8
code-server --install-extension charliermarsh.ruff


jq '. + {
    "workbench.colorTheme": "Default Dark Modern",  # Set the theme

    "editor.rulers": [80, 100, 120],  # Add specific vertical rulers
    "files.trimTrailingWhitespace": true,  # Automatically trim trailing whitespace
    "files.insertFinalNewline": true,  # Ensure files end with a newline

    "flake8.args": [
        "--max-line-length=100"  # Max line length for Python linting
    ]



}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
