"""
Contamination estimation and filtering
"""

rule learn_read_orientation:
    input:
        "raw_variants/all.f1r2.tar.gz"
    output:
        "raw_variants/all.model.tar.gz"
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk LearnReadOrientationModel -I {input} -O {output}"

rule get_pileup_summaries:
    input:
        bam="Analysis_ready/tumor/Recalibrated_processed_{tumor}.bam",
        vcf=config["exac"]
    output:
        "raw_variants/{tumor}.pileup.table"
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk GetPileupSummaries -I {input.bam} -V {input.vcf} -O {output}"

rule calculate_contamination:
    input:
        "raw_variants/{tumor}.pileup.table"
    output:
        contam="raw_variants/{tumor}.calculate.table",
        segments="raw_variants/{tumor}.segments.table"
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk CalculateContamination -I {input} -O {output.contam} --tumor-segmentation {output.segments}"

rule filter_mutect_calls:
    input:
        vcf="raw_variants/all.rawvcf.gz",
        contam="raw_variants/{tumor}.calculate.table",
        segments="raw_variants/{tumor}.segments.table",
        model="raw_variants/all.model.tar.gz"
    output:
        "filtered_variants/{tumor}.filtered_vcf.gz"
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk FilterMutectCalls -V {input.vcf} --contamination-table {input.contam} -O {output}"
