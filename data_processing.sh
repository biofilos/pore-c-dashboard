#!/usr/bin/env bash

CPU=32

# create a directory for the raw data
mkdir -p RawData
# create a directory for the reference genome
mkdir -p ref
# Download human genome
cd ref || exit
[ ! -f genome.tar.gz ] && [ ! -f genome.fa ] && curl -o genome.tar.gz https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz

# Unzip the file
#[ ! -d chroms ] && tar xf genome.tar.gz

# Download chrom.sizes
[ ! -f pre.chrom.sizes ] && [ ! -f chrom.sizes ] && curl -o pre.chrom.sizes https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes

if [ ! -f genome.fa ]; then
  # Keep only chromosomes
  for chr in {1..22} X Y; do
      grep -w "chr$chr" pre.chrom.sizes >> chrom.sizes
      cat chroms/chr"$chr".fa >> genome.fa
  done
fi

# Clean files
[ -f pre.chrom.sizes ] && rm pre.chrom.sizes

[ -d chroms ] && rm -rf chroms

[ -f genome.tar.gz ] && rm genome.tar.gz
cd ..

annopy="$PWD/HiPore-C/Scripts/Read_Fragment_Annotation.py"
genome_digest_frag="$PWD/DpnII_GRCh38.vd.fragments.csv"
#cooler digest -o hg38_DpnII_digetstion_fragment.bed ref/chrom.sizes ref/genome.fa DpnII

ReAlignBash="$PWD/HiPore-C/Scripts/minimap2_subreads_remapping.sh"
ChromCheckBash="$PWD/HiPore-C/Scripts/multichrom_check.sh"

#echo "chrom,start,end,fragment_length,fragment_id" > DpnII_GRCh38.vd.fragments.csv  #DpnII_GRCh38.vd.fragments.csv with columns [chrom, start, end, fragment_length, fragment_id]
#awk -v OFS="," '{print $1,$2,$3,$3-$2,NR}' hg38_DpnII_digetstion_fragment.bed >> DpnII_GRCh38.vd.fragments.csv
# Download SraRunTable.txt
grep -v Run SraRunTable.txt | cut -d ',' -f 1 | while IFS= read -r line; do
  # download data
#  [ ! -f "$line".fastq ] && [ ! -f "$line".fastq.gz ] && [ ! -f Rawdata/"$line".fastq.gz ] && fastq-dump "$line"

  # compress data
#  [ ! -f "$line".fastq.gz ] && gzip "$line".fastq

  # move data to Rawdata directory
#  [ ! -f Rawdata/"$line".fastq.gz ] && mv "$line".fastq.gz Rawdata/"$line".fastq.gz
    # align data
#  bash HiPore-C/Scripts/Alignment.sh "$PWD"/analysis "$PWD"/ref/genome.fa "$line".fastq.gz "$CPU"
  bash HiPore-C/Scripts/Fragment_Annotation_linux.sh $annopy "$PWD"/analysis "$PWD"/ref/genome.fa "$line".fastq.gz $genome_digest_frag  $ReAlignBash $ChromCheckBash

done

