
include lib/*.mk

## Builds all outputs and intermediate files
all: 5-query

# Target for creating all necessary folders.
checkdirs: $(dirs)
$(dirs):
	mkdir -p $@

# Git utils
## Perform a fast push to the remote git repository.
git-push:
	@bash $(git_dir)/fast-git-push.sh


# Build a .gitignore file, so changes in make paths are automatically updated.
maintenance: $(gitignore_file)
$(gitignore_file):
	$(file > $@,$(gitignore))

define gitignore
*~
$(outputs_dir)/*
$(data_dir)/*

endef
