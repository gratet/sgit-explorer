
#---------------------
# Sources and targets
#---------------------
query_list    := $(wildcard $(sql_dir)/*.sql)
query_targets := $(patsubst $(sql_dir)/%.sql,$(query_results_dir)/%.csv,$(query_list))


#-------
# Rules
#-------
.PHONY:4-query
## Execute SQL queries and get outputs (*.csv, *.shp, etc).
4-query: $(query_targets)

# pattern rule for query results
$(query_results_dir)/%.csv: $(sql_dir)/%.sql $(db) | checkdirs
	spatialite -header -csv $(word 2,$^) < $< > $@;


.PHONY:5-distribute
## Zip all query results
5-distribute: $(outputs_dir)/query_results_complete.zip

$(outputs_dir)/query_results_complete.zip: $(query_targets)
	zip -j $@ $^


#-------------------
# Cleaning strategy
#-------------------
mostly_clean += $(query_targets) 
mostly_clean += $(outputs_dir)/query_results_complete.zip


