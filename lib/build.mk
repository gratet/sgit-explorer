
#--------------
# Main targets
#--------------
db_raw      := $(outputs_dir)/atm$(sample_year)$(sample_size).db-raw
db          := $(outputs_dir)/atm$(sample_year)$(sample_size).db


#-------------
# Source data
#-------------

# ATM files
ifeq ($(sample_year), )
atm_files := $(wildcard $(data_dir)/$(atm_prefix)*.csv)
else
atm_files := $(wildcard $(data_dir)/$(atm_prefix)_$(sample_year)*.csv)
endif

sampled_atm_files := $(subst $(data_dir),$(sampled_files_dir),$(atm_files))
sampled_atm_flags := $(subst .csv,.loaded,$(sampled_atm_files))


# TP files
ifeq ($(sample_year), )
tp_files := $(wildcard $(data_dir)/$(tp_prefix)*.csv)
else
tp_files := $(wildcard $(data_dir)/$(tp_prefix)_$(sample_year)*.csv)
endif

sampled_tp_files := $(subst $(data_dir),$(sampled_files_dir),$(tp_files))
sampled_tp_flags := $(subst .csv,.loaded,$(sampled_tp_files))


#-------
# RULES
#-------

.PHONY:1-sample
## Sample source files (eg 'make 1-sample sample_size=1000 sample_year=2018' OR simply 'make 1-sample').
1-sample: $(sampled_atm_files) $(sampled_tp_files) | checkdirs
	@echo "===================="; \
	echo "Total files sampled: $(words $(sampled_atm_files) $(sampled_tp_files)) \
	($(words $(sampled_atm_files)) ATM + $(words $(sampled_tp_files)) TP)"; \
	echo ""

# Pattern rule for sampling
$(sampled_files_dir)/%.csv: $(data_dir)/%.csv | checkdirs
ifeq ($(sample_size), )
	tail -n +2 $< > $@;
else
	head -n $(sample_size) $< | tail -n +2 > $@;
endif


.PHONY:2-build
## Builds a spatial database, then load raw data and some resources.
2-build: $(db_raw) $(sampled_atm_files) $(sampled_tp_files) $(sampled_atm_flags) $(sampled_tp_flags)

$(db_raw): $(ddl_dir)/create.sql
	spatialite $@ < $< >/dev/null

# pattern rule for importing loaded flags
$(sampled_files_dir)/$(atm_prefix)%.loaded: $(sampled_files_dir)/$(atm_prefix)%.csv
	echo '.separator ";"\n.import $< transactions_atm' | sqlite3 $(db_raw)

# pattern rule for importing TP
$(sampled_files_dir)/$(tp_prefix)%.loaded: $(sampled_files_dir)/$(tp_prefix)%.csv
	echo '.separator ";"\n.import $< transactions_tp' | sqlite3 $(db_raw)


.PHONY:3-setup
## Database setup from SQL scripts (eg rename, select, filter, index, vacuum...).
3-setup: $(db)

$(db): $(db_raw) $(ddl_dir)/setup-lookup-tables.sql $(ddl_dir)/setup-atm.sql $(ddl_dir)/setup-tp.sql
	cp $< $@
	spatialite $(db) < $(word 2,$^) >/dev/null
	sqlite3 $(db) < $(word 3,$^)
	sqlite3 $(db) < $(word 4,$^)
	chmod 400 $(db)

