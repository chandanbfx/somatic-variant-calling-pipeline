"""
Reporting stats
"""

rule generate_stats:
    input:
        vcf="raw_variants/all.rawvcf.gz",
    output:
        "variants/Allvcf_stats.txt"
    conda:
        "envs/annotation.yaml"
    shell:
        "rtg vcfstats {input.vcf} > {output}"
