
# Logging strategy based on:
# https://www.cmcrossroads.com/article/tracing-rule-execution-gnu-make
#SHELL = $(warning BUILDING $@ $(if $<, (from $<)) $(if $?, ($? newer)))$(OLD_SHELL) -x

TRACE := TRUE

ifeq ($(TRACE),TRUE)

OLD_SHELL := $(SHELL)

define log-message

  BUILDING: $@ 
$(if $^,      FROM: $^)
$(if $?,     NEWER: $?)
    RECIPE:
endef

SHELL = $(warning $(log-message))$(OLD_SHELL)
endif

