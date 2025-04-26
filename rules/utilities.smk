"""
Quality control and reporting
"""

rule generate_stats:
    input:
        vcf="raw_variants/all.rawvcf.gz",
        filtered=expand("filtered_variants/{tumor}.filtered_vcf.gz", tumor=config["tumor_ids"]),
        annotated=expand("annotation/{tumor}.AnnFun_clinVar.vcf", tumor=config["tumor_ids"])
    output:
        "variants/Allvcf_stats.txt"
    conda:
        "envs/annotation.yaml"
    shell:
        "rtg vcfstats {input.vcf} > {output}"
