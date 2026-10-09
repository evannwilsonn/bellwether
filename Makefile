.PHONY: all setup extract load build freshness docs dashboard serve clean

all: extract load build dashboard   ## run the whole pipeline end to end

setup:        ## install dependencies
	pip install -r requirements.txt

extract:      ## download the public datasets + manifest into data/raw
	python ingest/extract.py

load:         ## land the raw files in the warehouse (DuckDB)
	python ingest/load_raw.py

build:        ## seed, run and test every dbt model
	dbt build

freshness:    ## check source freshness against the load timestamp
	dbt source freshness

docs:         ## generate the dbt docs site with lineage graph
	dbt docs generate --static && echo "Open target/static_index.html"

dashboard:    ## export the reporting marts for the dashboard
	python dashboard/export_data.py

serve:        ## open the dashboard at http://localhost:8000
	cd dashboard && python -m http.server 8000

clean:
	rm -rf target warehouse/*.duckdb data/raw dashboard/data.json
