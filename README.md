# sigit-explorer

This repository contains a set of scripts and SQL queries needed to replicate a framework to manage a medium or large volume of data from the logs created by an AFC system and facilitate its exploitation through SQL queries. This AFC framework is divided into three different layers: content layer, services layer and application layer. Following, each of the pieces included in this repository is detailed.

### Content layer

A set of scripts to create an empty dummy database following the database model [[3]](#3), to load all datasets into a relational database and to set up the database for increasing the database performance (e.g. applying normalisation, creating indexes and useful views).

### Service layer

A set of SQL-encoded queries are included. These queries are formulated using a Domain-Specific Language (DSL) called MobilityFNC [[2]](#2). Each query is named using this convention, and both files --- the SQL query defined by the database experts and the results file --- are inseparable. The key element in this solution is that the common nomenclature enables the creation of a repository of the query outputs, and so avoiding the duplication of efforts when creating new queries. 

### Application layer

A R script to perform a model-based clustering analysis. Based on the results the script creates some visualizations in order to be usefull to make decisions. 

<br/>

## References:
<a id="1">[1]</a> 
Gutiérrez, A., Domènech, A., Zaragozí, B., & Miravet, D. (2020). Profiling tourists' use of public transport through smart travel card data. <em>Journal of Transport Geography</em>, 88, 102820.

<a id="2">[2]</a> 
Zaragozí, B., Gutiérrez, A., & Trilles, S. (2020). Towards an Affordable GIS for Analysing Public Transport Mobility Data: A Preliminary File Naming Convention for Avoiding Duplication of Efforts. <em>In GISTAM</em> (pp. 302-309).

<a id="3">[3]</a> 
Zaragozí, B., Trilles, S., Miravet, D., & Gutiérrez, A. (Submitted). Development of a common framework for analyzing public transport smart card data. <em>Submitted in Sustainability, MDPI</em> (pp. 302-309).
