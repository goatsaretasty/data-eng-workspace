# Data Engineering Workspace

Cloud dev environment via GitHub Codespaces — no local install, runs on GitHub's compute instead of your laptop.

## Getting started

1. Click **Code → Codespaces → Create codespace on main** on this repo (or `gh codespace create` from the CLI).
2. Wait for the container to build (installs Python + pandas/polars/duckdb/dbt/JupyterLab from `requirements.txt`).
3. Open a terminal in the Codespace and run `jupyter lab --ip=0.0.0.0` or just start writing scripts/notebooks — everything executes on GitHub's servers.

## What's in here

- `.devcontainer/devcontainer.json` — defines the cloud environment (2 CPU / 4GB, well beyond what the local laptop can spare)
- `requirements.txt` — core data engineering stack: pandas, polars, DuckDB (in-process SQL warehouse), dbt-duckdb (transformation layer), JupyterLab

## Why this instead of local

Local dev on this machine chokes under the RAM required for even one Electron IDE plus a browser. Codespaces runs the actual compute (Docker, DuckDB, dbt, Jupyter kernels) on GitHub's infrastructure; the laptop only needs to render a browser tab.

Free tier: 60 core-hours/month, more with GitHub Pro/paid plans.
