#!/bin/bash

# Set the path to the directory containing the paired-end FASTQ files
SEQ_DIR=$1

# Import the paired-end FASTQ files into QIIME 2
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path "$SEQ_DIR" \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path paired-end-demux.qza

# Perform quality control on the paired-end FASTQ files
qiime demux summarize \
  --i-data paired-end-demux.qza \
  --o-visualization paired-end-demux-summary.qzv

# Denoise the paired-end sequences to generate feature tables and representative sequences
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs paired-end-demux.qza \
  --p-trim-left-f 13 \
  --p-trim-left-r 13 \
  --p-trunc-len-f 275 \
  --p-trunc-len-r 240 \
  --o-representative-sequences rep-seqs.qza \
  --o-table table.qza \
  --o-denoising-stats denoising-stats.qza

# Tabulate the representative sequences
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv  

# Export the tabulated representative sequences to a folder named Export_1
mkdir Export_1
qiime tools export \
  --input-path rep-seqs.qzv \
  --output-path Export_1
mv rep-seqs.qzv Export_1

# Assign taxonomy to the representative sequences using the SILVA database
qiime feature-classifier classify-sklearn \
  --i-classifier ./Classifier/silva-138-99-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

# Review the taxonomy associated with the sequences 
qiime metadata tabulate \
  --m-input-file ./taxonomy.qza \
  --o-visualization ./taxonomy.qzv

# Export the tabulated taxonomy to a folder named Export_2
mkdir Export_2
qiime tools export \
  --input-path taxonomy.qzv \
  --output-path Export_2
mv taxonomy.qzv Export_2

# Generate a taxonomic bar plot
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --o-visualization taxa-bar-plots.qzv

# Export the taxonomic bar plot to a folder named Export_3
mkdir Export_3
qiime tools export \
  --input-path taxa-bar-plots.qzv \
  --output-path Export_3
mv taxa-bar-plots.qzv Export_3
