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

## Portfolio project: NYC Yellow Taxi pipeline

An ELT pipeline built entirely in the cloud dev environment above:

- **Extract/Load**: DuckDB reads NYC TLC's public Yellow Taxi trip data directly from its S3-backed HTTPS source as Parquet — no download or external database needed (`models/staging/stg_yellow_tripdata.sql`).
- **Transform**: dbt models clean and aggregate the raw trips into two marts — `daily_summary` (volume/revenue by day) and `hourly_patterns` (demand and tipping by hour) — with schema tests (`not_null`, `unique`) enforcing data quality.
- **Document/Publish**: `dbt docs generate` builds a static site (data lineage graph, column-level docs, compiled SQL) published via GitHub Pages — see the live link at the top of the repo page once Pages is enabled.

Rebuild it yourself inside the Codespace:

```bash
dbt deps --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
dbt docs generate --profiles-dir . --static
```
