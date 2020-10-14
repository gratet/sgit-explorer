FROM rocker/geospatial:3.5.3

# Complements to rocker/geospatial
RUN install2.r --error --repos 'https://cran.rstudio.com/' \
	cowplot \
	ggforce \
	ggrepel \
	ggspatial \
	scatterpie

# Descriptive tables
RUN install2.r --error --repos 'https://cran.rstudio.com/' \
	tables \
	table1 \
	furniture \
	arsenal

# Descriptive plots and LPA
RUN install2.r --error --repos 'https://cran.rstudio.com/' \
	fastDummies \
	ggcorrplot \
	ggalluvial \
	naniar \
	sugrrants \
	tsibble \
	tidyLPA

