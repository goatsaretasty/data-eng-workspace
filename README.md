# Data Engineering Workspace

Hey — future me. This is the repo where the pivot started.

Short version: the 2017 MacBook was choking on three tabs, so instead of fighting it, I moved the actual work to the cloud and kept the laptop as a window into it. Everything here — Python, DuckDB, dbt, Jupyter — runs inside a GitHub Codespace, not on that poor 8GB machine. If you're reading this because you forgot how any of it fits together, here's the map.

## How to get back in

1. On the repo page: **Code → Codespaces → Create codespace on main** (or `gh codespace create` if you're in a terminal already).
2. Give it a minute or two to build — it's installing pandas/polars/DuckDB/dbt/JupyterLab from `requirements.txt`.
3. You land in a full VS Code in the browser. Open a terminal there and you're working — the laptop is just rendering pixels at that point.

## What's actually in here

- `.devcontainer/devcontainer.json` — the recipe for the cloud box: Python 3.11, an SSH server so I can drive it from a terminal too, and the extensions worth having (Jupyter, SQLTools, the dbt power-user extension).
- `requirements.txt` — the core stack: pandas, polars, DuckDB (a whole SQL warehouse that lives in a single process), dbt-duckdb (the transformation layer), JupyterLab.
- `models/` + `dbt_project.yml` / `profiles.yml` — the first real pipeline, described below.

## Why cloud instead of local — the thing to remember

That old MacBook has 8GB of soldered RAM and two cores. Running Chrome *and* an Electron IDE *and* anything data-shaped on it was never going to work — that's not a "clean up your disk" problem, it's a hardware ceiling. Codespaces sidesteps it entirely: GitHub's servers do the actual compute, the laptop just needs a browser tab open. Free tier is 60 core-hours/month, which is plenty for practice and portfolio work.

## The first project: NYC Yellow Taxi pipeline

Proof this setup actually works, built end to end inside the Codespace above:

- **Extract/Load** — `models/staging/stg_yellow_tripdata.sql` has DuckDB reading NYC TLC's public Yellow Taxi trip data straight off its HTTPS/S3 source as Parquet. No download step, no external database — DuckDB just queries the file where it lives.
- **Transform** — dbt cleans that into two marts: `daily_summary` (trip volume and revenue by day) and `hourly_patterns` (demand and tipping by hour of day), with `not_null`/`unique` tests on both so bad data doesn't sneak through quietly.
- **Publish** — `dbt docs generate` builds a static site with the lineage graph and column-level docs, and it's live at **http://adecode.me/data-eng-workspace/** via GitHub Pages, serving straight out of `docs/`.

To rebuild it from scratch inside the Codespace:

```bash
dbt deps --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
dbt docs generate --profiles-dir . --static
```

If you're future-me scoping the next project: same pattern applies — pick a public dataset, land it in DuckDB, model it in dbt, publish the docs. Repeat.
