nextflow.enable.dsl=2

params.genome = file("./ref/genome.fa")
params.chrom_sizes = file("./ref/chrom.sizes")
params.fq = "./reads/*"
params.enz = "DpnII"
params.cpu = 24


include { enzDigest } from "./modules/utils.nf"
include {align} from "./modules/alignment.nf"

workflow {
    enzDigest([params.enz, file(params.chrom_sizes), file(params.genome)])
    Channel.fromPath(params.fq).set{fqs}
    align(fqs)

}

