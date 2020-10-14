
#---------------
# CLEAN TARGETS
#---------------

.PHONY: mostlyclean
## Like ‘clean’, but not deleting a few files that normally don’t want to recompile (e.g. sample data, working DB, etc).
mostlyclean:
	echo -n "Deleting most of the files created by this Makefile... "; \
	rm $(mostly_clean); \
	echo "Done."


.PHONY: distclean
## Delete all files in the 'dist' directory (EVEN THE WORKING DB!!!!)
distclean:
	@echo -n "Deleting all the outputs... "; \
	rm $(distclean); \
	echo "Done."


#TODO: Remove logs and overviews, when ready.
.PHONY: clean
## Delete all files created by this Makefile.
clean: mostlyclean
	echo -n "Deleting all the outputs created by this Makefile... "; \
	rm $(clean); \
	echo "Done."


#TODO: Remove .gitignore and setting files, when ready.
.PHONY: maintainer-clean
## Delete almost everything that can be reconstructed with this Makefile. It includes everything deleted by clean, plus more.
maintainer-clean: clean
	echo -n "Deleting almost everything that can be reconstructed with this Makefile... "; \
	rm $(mantainer_clean); \
	echo "Done."


