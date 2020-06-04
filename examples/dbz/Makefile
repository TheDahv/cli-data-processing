all : results.csv
	@echo 'Levels downloaded, processed, and saved to results.csv'
.PHONY: clean

levels.html:
	@echo 'Downloading raw input from the Internet...'
	@./1-get-the-raw-input.sh

extracted-table-rows.json: levels.html
	@echo 'Extracting the table rows...'
	@./2-extract-tables.sh

extracted-stats.ndjson: extracted-table-rows.json
	@echo 'Pulling stats and calculating aggregate statistics...'
	@./3-extract-stats-from-table.sh

results.csv: extracted-stats.ndjson
	@echo 'Writing results to CSV...'
	@./4-produce-results.sh

clean:
	@rm -f levels.html extracted-table-rows.json extracted-stats.ndjson results.csv
	@echo 'Done'
