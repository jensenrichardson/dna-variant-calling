rule GetPileupSummaries:
	input:
		bam="06-ApplyRecalibration/{sample}.recalibrated.bam",
		bai="06-ApplyRecalibration/{sample}.recalibrated.bai",
		common=config["common_variants"]
	output:
		table="09-GetPileupSummaries/{sample}.pileups.table"
	log:
		"09-GetPileupSummaries/{sample}.log"
	resources:
		runtime=lambda wildcards, attempt: 15 * attempt
	shell:
		"gatk GetPileupSummaries "
		"-I {input.bam} "
		"-V {input.common} "
		"-L {input.common} "
		"-O {output.table} "
		"&> {log} "
