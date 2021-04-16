from snakemake.utils import validate
import pandas as pd

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config/config.yaml"
#validate(config, schema="../schemas/config.schema.yaml")

#samples = pd.read_csv(config["samples"], sep="\t").set_index("sample", drop=False)
#samples.index.names = ["sample_id"]
#validate(samples, schema="../schemas/samples.schema.yaml")

rule Mutect2:
	input:
		bam="06-ApplyRecalibration/{sample}.recalibrated.bam",
		bai="06-ApplyRecalibration/{sample}.recalibrated.bai",
		ref=config["ref_gen"],
		germline=config["germline_resource"],
		pon=config["panel_of_normals"]
	output:
		vcf="07-Mutect2/{sample}.mutect2.vcf",
		idx="07-Mutect2/{sample}.mutect2.vcf.idx",
		stats="07-Mutect2/{sample}.mutect2.vcf.stats",
		f1r2="07-Mutect2/{sample}.mutect2.f1r2.tar.gz"
	log:
		"07-Mutect2/{sample}.log"
	resources:
		runtime=lambda wildcards, attempt: 30 + 60 * (attempt+1) + max(0, 90 * (attempt - 2)),
		cores=16
	shell:
		"OMP_NUM_THREADS={resources.cores} gatk Mutect2 "
		"-R {input.ref} "
		"-I {input.bam} "
		"--germline-resource {input.germline} "
		"--f1r2-tar-gz {output.f1r2} "
		"--panel-of-normals {input.pon} "	
		"-O {output.vcf} "
		"&> {log} "
