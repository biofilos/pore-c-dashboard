# Pore-C Dashboard

This is a dashboard in the form of jupyter notebooks and auxiliary scripts to evaluate the quality of Hi-C data from Nanopore sequencing experiments.

## Sample data
The data used for our tests comes from the SRA Bioproject "Pore-C: Combination of chromatin capture assay and Oxford Nanopore Technology long read sequencing. (human)" [PRJNA627432](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA627432). Specific runs are described below.

| Run          | Sample       | Cell line | Cell type                                | Device     | Enzyme* | Bases   |
|--------------|--------------|-----------|------------------------------------------|------------|---------|---------|
| SRR11589389  | SAMN14669699 | GM12878   | EBV transformed lymphoblastoid cell line | MinION     | DpnII   | 6.72 G  |
| SRR11589414  | SAMN14669701 | HG002     | EBV transformed lymphoblastoid cell line | PromethION | DpnII   | 71.86 G |

* The enzyme information was extracted from the [supplementary table 2](https://static-content.springer.com/esm/art%3A10.1038%2Fs41587-022-01289-z/MediaObjects/41587_2022_1289_MOESM1_ESM.pdf) of the [article](https://www.nature.com/articles/s41587-022-01289-z#Sec42), by looking at the read "yield" column of such table, and the "Bases" column in the SRA selector

The purpose of this data is to exemplify a comparison of two Hi-C matrices generated using different devices, and to show the effect of the sequencing depth on the quality of the data.

