nextflow.enable.dsl=2

workflow align {
  take: fastq
  main:
    readlist(fastq)
    ngmlr(fastq) | samToPaf
    unaligned(fastq, samToPaf.out, readlist.out)
    minimap2(fastq)
    mergePaf(ngmlr.out, minimap2.out)
  emit:
    mergePaf.out

}

process readlist {
  cpus 1
  input:
    path fastq
  output:
    path 'readlist.txt'
  script:
  """
  seqkit fx2tab ${fastq} -i -n -l | awk '{print \$1}' | sort > readlist.txt
  """
}

process ngmlr {
  cpus params.cpu
  input:
    path(fastq)
  output:
    path("${fastq.baseName}.ngmlr.sam")
  script:
  """
  ngmlr -t ${params.cpu} --subread-length 256 --max-segments 5 -r ${params.genome} -q ${fastq} -x ont -o ${fastq.baseName}.ngmlr.sam
  """
}

process samToPaf {
  cpus 1
  input:
    path(sam)
  output:
    path("${sam.baseName}.paf")
  script:
  """
    paftools.js sam2paf ${sam} > ${sam.baseName}.paf
  """
}

process unaligned {
  cpus 1
  input:
    path(fq)
    path(paf)
    path(readlist)
  output:
    path("${paf.baseName}.unaligned.fq")
  script:
  """
  awk '{print \$1}' ${paf} | sort | uniq > ${paf.baseName}.aligned.txt
  comm ${readlist} ${paf.baseName}.aligned.txt -3 | awk '{print \$1}' > unaligned.txt
  seqkit subseq ${fq} unaligned.txt > ${paf.baseName}.unaligned.fq
  """
}

process minimap2 {
  cpus params.cpu
  input:
    path(fastq)
  output:
    path("${fastq.baseName}.minimap2.paf")
  script:
  """
  minimap2 -x map-ont -B 3 -O 2 -E 5 -k13 -t ${params.cpu} -c ${params.genome} ${fastq} > ${fastq.baseName}.minimap2.paf
  """
}

process mergePaf {
  cpus 1
  input:
    path(ngmlr_paf)
    path(minimap2_paf)
  output:
    path("${ngmlr_paf.baseName}.reads_map.paf")
  script:
  """
  awk -v OFS="\t" '(\$12>0){print \$1,\$2,\$3,\$4,\$5,\$6,\$7,\$8,\$9,\$10,\$11,\$12,\$17}' ${ngmlr_paf}  > ${ngmlr_paf.baseName}.reads_map.paf
  awk -v OFS="\t" '(\$12>0){print \$1,\$2,\$3,\$4,\$5,\$6,\$7,\$8,\$9,\$10,\$11,\$12,\$22}' ${minimap2_paf} >> ${ngmlr_paf.baseName}.reads_map.paf
  """
}