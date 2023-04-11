#!/bin/bash

# Prompt the user to enter the name of the directory containing the paired-end fastq files
read -p "Enter the name of the directory containing the paired-end fastq files: " input_dir

# Import your paired-end fastq files as QIIME 2 artifacts
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $input_dir \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-paired-end.qza

# Quality filter your reads to remove low-quality bases and join overlapping paired-end reads
qiime vsearch join-pairs \
  --i-demultiplexed-seqs demux-paired-end.qza \
  --p-minovlen 50 \
  --p-maxdiffs 15 \
  --p-max-ee 2.0 \
  --o-joined-sequences demux-joined.qza \
  --verbose

# Denoise your sequences using the DADA2 algorithm and filter out chimeras
qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux-joined.qza \
  --p-trim-left 0 \
  --p-trunc-len 250 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza \
  --verbose

# Train a classifier on the SILVA reference database
qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads /path/to/silva-138-99-seqs.qza \
  --i-reference-taxonomy /path/to/silva-138-99-tax.qza \
  --o-classifier silva-138-99-nb-classifier.qza

# Classify your sequences taxonomically using the trained classifier
qiime feature-classifier classify-sklearn \
  --i-classifier silva-138-99-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

# Generate a taxonomic bar plot
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --o-visualization taxa-bar-plots.qzv
