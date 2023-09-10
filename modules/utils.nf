nextflow.enable.dsl=2

process enzDigest {
    conda 'cooler'
    cpus = 1
  input:
    tuple val(enz), path(chrom_sizes), path(genome)
  output:
    path("${enz}.vd.fragments.csv")
  script:
  """
    cooler digest -o ${enz}.bed ${chrom_sizes} ${genome} ${enz}
    echo "chrom,start,end,fragment_length,fragment_id" > ${enz}.vd.fragments.csv
    awk -v OFS="," '{print \$1,\$2,\$3,\$3-\$2,NR}' ${enz}.bed >> ${enz}.vd.fragments.csv
  """
}
