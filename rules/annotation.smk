"""
Variant annotation and post-processing
"""

rule funcotator:
    input:
        vcf="filtered_variants/{tumor}.filtered_vcf.gz",
        datasource=config["data_sources"]
    output:
        vcf="annotation/{tumor}.AnnFuncotator.vcf.gz",
        index="annotation/{tumor}.AnnFuncotator.vcf.gz.tbi"
    params:
        resources="funcotator_data_sources",
        mem_gb=lambda wildcards, resources: int(resources.mem_mb) // 1024,
        uncompressed_vcf = lambda wildcards, output: output.vcf.replace(".gz", "")
    resources: mem_mb = config["annotationRam"], disk_mb = config["annotationDisk"]
    threads: config.get("annotationThreads")
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk --java-options -Xmx{params.mem_gb}G Funcotator  -V {input.vcf} --data-sources-path {params.resources} -O {params.uncompressed_vcf} --output-file-format VCF && bgzip -c {params.uncompressed_vcf} > {output.vcf} && tabix -p vcf {output.vcf} && rm -f {params.uncompressed_vcf} "

rule snpsift_dbsnp:
    input:
        vcf="annotation/{tumor}.AnnFuncotator.vcf.gz",
        dbsnp=config["dbSNP"]
    output:
        "annotation/{tumor}.AnnFun_dbSNP.vcf.gz"
    conda:
        "envs/annotation.yaml"
    shell:
        "SnpSift annotate {input.dbsnp} {input.vcf} > {output}"

rule snpsift_clinvar:
    input:
        vcf="annotation/{tumor}.AnnFuncotator.vcf.gz",
        clinvar=config["clinVar"]
    output:
        "annotation/{tumor}.AnnFun_clinVar.vcf.gz"
    conda:
        "envs/annotation.yaml"
    shell:
        "SnpSift annotate {input.clinvar} {input.vcf} > {output}"
