# Pore-C Dashboard

This is a dashboard in the form of jupyter notebooks and auxiliary scripts to evaluate the quality of Hi-C data from Nanopore sequencing experiments.

## Sample data
The data used for our tests comes from the SRA Bioproject "Pore-C: Combination of chromatin capture assay and Oxford Nanopore Technology long read sequencing. (human)" [PRJNA627432](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA627432). Specific runs are described below.

| Run          | Sample       | Cell line | Cell type                                | Device     | File size |
|--------------|--------------|-----------|------------------------------------------|------------|-----------|
| SRR11589389  | SAMN14669699 | GM12878   | EBV transformed lymphoblastoid cell line | MinION     | 5.55 Gb   |
| SRR11589390  | SAMN14669700 | HG002     | EBV transformed lymphoblastoid cell line | PromethION | 58.62 Gb  |

The purpose of this data is to exemplify a comparison of two samples sequenced on different devices. The data is not meant to be representative of the quality of Hi-C data from Nanopore sequencing experiments.