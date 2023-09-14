nextflow.enable.dsl=2

workflow ann {
    take:
      data
      digest

    main:
        data.map{it[1][0]}
        | ix | set{fai}
        fai.concat(data)
        .groupTuple()
        .map{[it[0], it[1][1][0], it[1][1][1], it[1][0]]}.set{toAnn}
        annopy(toAnn, digest)
}

process ix {
    cpus 1
    conda "seqkit"
    input: path(fq)
    output: tuple val("${fq.baseName.replace('.fastq', '')}"), path("${fq.baseName.replace('.fastq', '')}.fai")
    script:
    """
    seqkit fx2tab ${fq} -i -n -l > ${fq.baseName.replace('.fastq', '')}.fai
    """
}

process annopy {
    conda "pandas numpy joblib seqtk minimap2"
    cpus params.cpu
  input:
    tuple val(name), path(fq), path(paf), path(fai)
    path(digest)
  output:
    path("Read_Align_Fragment_RvdF_${name}.csv")
  script:
  """
    python $projectDir/bin/Read_Fragment_Annotation.py ${fq} ${paf} . ${params.genome} ${digest} $projectDir/bin/minimap2_subreads_remapping.sh $projectDir/bin/multichrom_check.sh ${fai} ${params.cpu}
    mv Read_Align_Fragment_RvdF.csv Read_Align_Fragment_RvdF_${name}.csv
  """
}