rule CalculateContamination:
	input:
		table="09-GetPileupSummaries/{sample}.pileups.table"
	output:
		table="10-CalculateContamination/{sample}.contamination.table"
	log:
		"10-CalculateContamination/{sample}.log"
	resources:
		runtime=lambda wildcards, attempt: 10 * attempt
	shell:
		"gatk CalculateContamination "
		"-I {input.table} "
		"-O {output.table} "
		"&> {log} "
