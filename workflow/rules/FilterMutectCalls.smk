rule FilterMutectCalls:
	input:
		vcf="07-Mutect2/{sample}.mutect2.vcf",
		contamination="10-CalculateContamination/{sample}.contamination.table",
		f1r2="08-LearnRead/{sample}.orientation-model.tar.gz",
		ref=config["ref_gen"]
	output:
		vcf="11-FilterMutectCalls/{sample}.filtered.vcf",
		idx="11-FilterMutectCalls/{sample}.filtered.vcf.idx",
		stats="11-FilterMutectCalls/{sample}.filtered.vcf.filteringStats.tsv"
	log:
		"11-FilterMutectCalls/{sample}.log"
	resources:
		runtime=lambda wildcards, attempt: 15 * attempt
	shell:
		"gatk FilterMutectCalls "
		"-V {input.vcf} "
		"-R {input.ref} "
		"--contamination-table {input.contamination} "
		"-ob-priors {input.f1r2} "
		"-O {output.vcf} "
		"&> {log} "
