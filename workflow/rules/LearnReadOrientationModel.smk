rule LearnReadOrientationModel:
	input:
		"07-Mutect2/{sample}.mutect2.f1r2.tar.gz"
	output:
		"08-LearnRead/{sample}.orientation-model.tar.gz"
	resources:
		runtime=lambda wildcards, attempt: 10 * attempt
	log:
		"08-LearnRead/{sample}.log"
	shell:
		"gatk LearnReadOrientationModel "
		"-I {input} "
		"-O {output} "
		"&> {log} "
