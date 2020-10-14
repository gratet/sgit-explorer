
#--------------
# Main options
#--------------
sample_size := 
sample_year := 2018
atm_prefix  := ATM
tp_prefix   := TP


#---------------------------
# Project structure (paths)
#---------------------------
lib_dir            := lib

sources_dir        := src
sql_dir            := $(sources_dir)/sql
ddl_dir            := $(sql_dir)/ddl
sqlt_dir           := $(sql_dir)/sqlt

resources_dir      := res
gis_dir            := $(resources_dir)/gis

outputs_dir        := dist
data_dir           := data


# Folders created by this makefile
dirs := $(outputs_dir)


# Helper files
contrib_dir        := contrib
git_dir            := $(contrib_dir)/git


#-------------------
# On-demand folders
#-------------------

# Both are undefined.
ifeq ($(sample_size), )
ifeq ($(sample_year), )
# Build non-sampled data and query results in the main directory.
sampled_files_dir:=$(outputs_dir)/sampled_data
query_results_dir:=$(outputs_dir)/query_results
dirs+=$(sampled_files_dir)
dirs+=$(query_results_dir)
endif
endif

# Both are defined.
ifneq ($(sample_size), )
ifneq ($(sample_year), )
# Build sampled data in a 'sample/year' sub-directory.
sampled_files_dir:=$(outputs_dir)/sampled_data/$(sample_size)/$(sample_year)
query_results_dir:=$(outputs_dir)/query_results/$(sample_size)/$(sample_year)
dirs+=$(sampled_files_dir)
dirs+=$(query_results_dir)
endif
endif

# Only sample_size is defined.
ifneq ($(sample_size), )
ifeq ($(sample_year), )
# Save sampled data in a 'sample/' root sub-directory.
sampled_files_dir:=$(outputs_dir)/sampled_data/$(sample_size)
query_results_dir:=$(outputs_dir)/query_results/$(sample_size)
dirs+=$(sampled_files_dir)
dirs+=$(query_results_dir)
endif
endif

# Only sample_year is defined.
ifeq ($(sample_size), )
ifneq ($(sample_year), )
# Save sampled data in a 'year/' root sub-directory.
sampled_files_dir:=$(outputs_dir)/sampled_data/$(sample_year)
query_results_dir:=$(outputs_dir)/query_results/$(sample_year)
dirs+=$(sampled_files_dir)
dirs+=$(query_results_dir)
endif
endif


