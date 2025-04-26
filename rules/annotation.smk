"""
Variant annotation and post-processing
"""

rule funcotator:
    input:
        vcf="filtered_variants/{tumor}.filtered_vcf.gz",
        datasource=config["data_sources"]
    output:
        "annotation/{tumor}.AnnFuncotator.vcf"
    params:
        resources="funcotator_data_sources"
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk Funcotator -V {input.vcf} --data-sources-path {params.resources} -O {output}"

rule snpsift_dbsnp:
    input:
        vcf="annotation/{tumor}.AnnFuncotator.vcf",
        dbsnp=config["dbSNP"]
    output:
        "annotation/{tumor}.AnnFun_dbSNP.vcf"
    conda:
        "envs/annotation.yaml"
    shell:
        "SnpSift annotate {input.dbsnp} {input.vcf} > {output}"

rule snpsift_clinvar:
    input:
        vcf="annotation/{tumor}.AnnFuncotator.vcf",
        clinvar=config["clinVar"]
    output:
        "annotation/{tumor}.AnnFun_clinVar.vcf"
    conda:
        "envs/annotation.yaml"
    shell:
        "SnpSift annotate {input.clinvar} {input.vcf} > {output}"
