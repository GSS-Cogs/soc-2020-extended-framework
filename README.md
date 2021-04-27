# Standard Occupational Classification (SOC) extension project (CSV on the Web)

This repo presents the [ONS' Standard Occupational Classification (SOC) extension project](https://www.ons.gov.uk/methodology/classificationsandstandards/standardoccupationalclassificationsoc/standardoccupationalclassificationsocextensionproject#dataset) as an RDF `skos:ConceptScheme` using [CSV on the Web](https://github.com/w3c/csvw) (CSVW). The repo is intended to be an example of how reference data can be successfully represented using CSVW and its ability to enable coining of HTTP URIs, from `.csv` files, for use on the Semantic Web.

- [`pipeline.R`](./pipeline.R) is an R script which reads in the excel file featured on the ONS website and transforms it into a [tidy](https://r4ds.had.co.nz/tidy-data.html) `.csv` file.
- [`soc-2020-extended-framework.csv`](./soc-2020-extended-framework.csv) is the result of the pipeline.
- [`soc-2020-extended-framework.csv-metadata.json`](./soc-2020-extended-framework.csv-metadata.json) is a CSV on the Web metadata file describing the contents of the `.csv`.
- [`output.ttl`](./output.ttl) contains the RDF representation following transformation from CSV on the Web using [Swirrl's `csv2rdf` library](https://github.com/Swirrl/csv2rdf). 

The RDF output can be recreated using the included `Dockerfile` by running the following from the project's root:

```sh
docker build ./docker --tag csv2rdf:0.4.4

docker run --rm -v $PWD:/workspace -w /workspace -it csv2rdf:0.4.4 \
/usr/local/bin/csv2rdf -u soc-2020-extended-framework.csv-metadata.json -m annotated -o output.ttl
```