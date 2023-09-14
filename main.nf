nextflow.enable.dsl=2

params.genome = file("./ref/genome.fa")
params.chrom_sizes = file("./ref/chrom.sizes")
params.fq = "./reads/*.fastq.gz"
params.enz = "DpnII"
params.cpu = 24


include { enzDigest } from "./modules/utils.nf"
include {align} from "./modules/alignment.nf"
include {ann} from "./modules/annotation.nf"

workflow {
    fq = Channel.fromPath(params.fq)
    enzDigest([params.enz, params.chrom_sizes, params.genome]).set{enz}

    align(fq).map{[it.baseName, it]}.set{alnGroup}
    fq.map{[it.baseName.replace(".fastq", ""), it]}.set{fqGroup}
    fqGroup.concat(alnGroup).groupTuple().set{allGroup}
    ann(allGroup, enz)
    

}

