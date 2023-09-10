nextflow.enable.dsl=2

workflow ann {
    take:
        fq
        digest
        paf
    main:
        ix(fq)
        annopy(fq, paf, digest, ix.out)
}

process ix {
    input: path(fq)
    output: path("${fq.baseName.replace('.fastq', '')}.fai")
    script:
    """
    seqkit fx2tab ${fq} -i -n -l > ${fq.baseName.replace('.fastq', '')}.fai
    """
}
process gvdf {
  input:
    path(fq)
  output:
  
  script:
  """
  
  """
}

process annopy {
    conda "pandas numpy joblib"
  input:
    path(fq)
    path(paf)
    path(digest)
    path(fai)
  output:
    path("Read_Align_Fragment_RvdF.csv")
  script:
  """
    python $projectDir/bin/Read_Fragment_Annotation.py ${fq} ${paf} . ${params.genome} ${digest} $projectDir/bin/minimap2_subreads_remapping.sh $projectDir/bin/multichrom_check.sh ${fai}
  """
}