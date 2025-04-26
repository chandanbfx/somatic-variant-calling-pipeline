"""
Process input BAM files (mark duplicates, recalibration)
"""
rule sort_coordinateNormal:
    input:
        bam="sorted_reads/normal/RmDuplicates_{normal}.bam"
    output:
        "processed/normal/RmDup.Sorted.{normal}.bam"
    resources: 
        mem_mb=config["gatkRam"], 
        disk_mb=config["gatkDisk"]
    threads: config.get("gatkThreads")
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk SortSam -I {input.bam} -O {output} -SO coordinate"

rule base_recalibrationNormal:
    input:
        bam="processed/normal/RmDup.Sorted.{normal}.bam",
        known=config["known_Sites"],
        fa="reference/chr1.fa"
    output:
        table="processed/normal/{normal}.recal.table"
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk BaseRecalibrator -I {input.bam} -R {input.fa} "
        "--known-sites {input.known} -O {output.table}"

rule apply_recalibrationNormal:
    input:
        fa="reference/chr1.fa",
        bam="processed/normal/RmDup.Sorted.{normal}.bam",
        table="processed/normal/{normal}.recal.table",
    output:
        file="Analysis_ready/normal/Recalibrated_processed_{normal}.bam",
        index="Analysis_ready/normal/Recalibrated_processed_{normal}.bam.bai"
    resources:  
        mem_mb=config["gatkRam"], 
        disk_mb=config["gatkDisk"]
    threads: config.get("gatkThreads")
    conda:
        "envs/somatic.yaml"
    log:
        "logs/gatkApplyBQSR/{normal}.log"
    shell:
        "gatk --java-options -Xmx56G ApplyBQSR "
        "-I {input.bam} -R {input.fa} "
        "--bqsr-recal-file {input.table} "
        "-O {output.file}"

rule sort_coordinateTumor:
    input:
        bam="sorted_reads/tumor/RmDuplicates_{tumor}.bam"
    output:
        "processed/tumor/RmDup.Sorted.{tumor}.bam"
    resources: 
        mem_mb=config["gatkRam"], 
        disk_mb=config["gatkDisk"]
    threads: config.get("gatkThreads")
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk SortSam -I {input.bam} -O {output} -SO coordinate"

rule base_recalibrationTumor:
    input:
        bam="processed/tumor/RmDup.Sorted.{tumor}.bam",
        known=config["known_Sites"],
        fa="reference/chr1.fa"
    output:
        table="processed/tumor/{tumor}.recal.table"
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk BaseRecalibrator -I {input.bam} -R {input.fa} "
        "--known-sites {input.known} -O {output.table}"

rule apply_recalibration:
    input:
        fa="reference/chr1.fa",
        bam="processed/tumor/RmDup.Sorted.{tumor}.bam",
        table="processed/tumor/{tumor}.recal.table",
    output:
        file="Analysis_ready/tumor/Recalibrated_processed_{tumor}.bam",
        index="Analysis_ready/tumor/Recalibrated_processed_{tumor}.bam.bai"
    resources:  
        mem_mb=config["gatkRam"], 
        disk_mb=config["gatkDisk"]
    threads: config.get("gatkThreads")
    conda:
        "envs/somatic.yaml"
    log:
        "logs/gatkApplyBQSR/{tumor}.log"
    shell:
        "gatk --java-options -Xmx56G ApplyBQSR "
        "-I {input.bam} -R {input.fa} "
        "--bqsr-recal-file {input.table} "
        "-O {output.file}"
