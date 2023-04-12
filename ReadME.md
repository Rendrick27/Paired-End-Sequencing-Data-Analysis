# QIIME 2 Pipeline for Paired-End Sequencing Data Analysis
This pipeline uses QIIME 2 to import, quality control, denoise, assign taxonomy, and generate a taxonomic bar plot for paired-end sequencing data. The pipeline consists of the following steps:

1-> Import the paired-end FASTQ files into QIIME 2

2-> Perform quality control on the paired-end FASTQ files

3-> Denoise the paired-end sequences to generate feature tables and representative sequences

4-> Tabulate the representative sequences

5-> Assign taxonomy to the representative sequences using the SILVA database

6-> Review the taxonomy associated with the sequences

7-> Generate a taxonomic bar plot

## Requirements
* QIIME 2 (version 2021.2 or later)
* SILVA database (version 138 or later)
* Paired-end sequencing data in FASTQ format

## Usage
To run the pipeline, execute the following command in the terminal:

`bash pipeline.sh SEQ_DIR`

where "SEQ_DIR" is the path to the directory containing the paired-end FASTQ files.

## Outputs
The pipeline generates the following outputs:
* paired-end-demux.qza: imported paired-end FASTQ files
* paired-end-demux-summary.qzv: quality control summary of the paired-end FASTQ files
* rep-seqs.qza: representative sequences of the denoised paired-end sequences
* table.qza: feature table generated from the denoised paired-end sequences
* denoising-stats.qza: denoising statistics generated during the denoising process
* rep-seqs.qzv: visualization of the representative sequences
* taxonomy.qza: taxonomic classification of the representative sequences
* taxonomy.qzv: visualization of the taxonomic classification
* taxa-bar-plots.qzv: taxonomic bar plot

The outputs are exported to the following directories:

* Export_1: exported rep-seqs.qzv
* Export_2: exported taxonomy.qzv
* Export_3: exported taxa-bar-plots.qzv

## Additional Information
For more information about QIIME 2, please refer to the official documentation.





