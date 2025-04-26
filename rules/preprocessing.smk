"""
BAM preprocessing for tumor and normal samples
"""

rule sort_queryname_normal:
    input:
         normalBam=lambda wildcards: f"{config['normal'][wildcards.normal]}.bam"
    output:
        "sorted_reads/sorted.{normal}.bam"
    params:
        mem_gb=lambda wildcards, resources: int(resources.mem_mb) // 1024
    resources:
         mem_mb=config["gatkRam"]
    threads: config["gatkThreads"]
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk --java-options -Xmx{params.mem_gb}G SortSam -I {input.normalBam} -O {output} -SO queryname"

rule mark_adapters_normal:
    input:
        "sorted_reads/sorted.{normal}.bam"
    output:
        bam="sorted_reads/normal/MarkAdapter_{normal}.bam",
        metrics="logs/MarkAdap/{normal}.metrics.txt"
    log:
        "logs/MarkAdap/{normal}.log"
    params:
        mem_gb=lambda wildcards, resources: int(resources.mem_mb) // 1024
    resources:
         mem_mb=config["gatkRam"]
    threads: config["gatkThreads"]
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk --java-options -Xmx{params.mem_gb}G  MarkIlluminaAdapters -I {input} -O {output.bam} -M {output.metrics}"

rule mark_duplicates_normal:
    input:
        "sorted_reads/normal/MarkAdapter_{normal}.bam"
    output:
        bam="sorted_reads/normal/RmDuplicates_{normal}.bam",
        metrics="logs/MarkDup/{normal}.metrics.txt"
    resources: mem_mb = config["gatkRam"], disk_mb = config["gatkDisk"]
    threads: config.get("gatkThreads")
    log:
        "logs/MarkDup/{normal}.log"
    params:
        mem_gb=lambda wildcards, resources: int(resources.mem_mb) // 1024
    resources:
         mem_mb=config["gatkRam"]
    threads: config["gatkThreads"]
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk --java-options -Xmx{params.mem_gb}G MarkDuplicates -I {input} -O {output.bam} -M {output.metrics}"

rule sort_queryname_tumor:
    input:
         tumorBam=lambda wildcards: f"{config['tumor'][wildcards.tumor]}.bam"
    output:
        "sorted_reads/sorted.{tumor}.bam"
    params:
        mem_gb=lambda wildcards, resources: int(resources.mem_mb) // 1024
    resources:
        mem_mb=config["gatkRam"]
    threads: config["gatkThreads"]
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk --java-options -Xmx{params.mem_gb}G SortSam -I {input.tumorBam} -O {output} -SO queryname"

rule mark_adapters_tumor:
    input:
        "sorted_reads/sorted.{tumor}.bam"
    output:
        bam="sorted_reads/tumor/MarkAdapter_{tumor}.bam",
        metrics="logs/MarkAdap/{tumor}.metrics.txt"
    log:
        "logs/MarkAdap/{tumor}.log"
    params:
        mem_gb=lambda wildcards, resources: int(resources.mem_mb) // 1024
    resources:
        mem_mb=config["gatkRam"]
    threads: config["gatkThreads"]
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk --java-options -Xmx{params.mem_gb}G MarkIlluminaAdapters  -I {input} -O {output.bam} -M {output.metrics}"

rule mark_duplicates_tumor:
    input:
        "sorted_reads/tumor/MarkAdapter_{tumor}.bam"
    output:
        bam="sorted_reads/tumor/RmDuplicates_{tumor}.bam",
        metrics="logs/MarkDup/{tumor}.metrics.txt"
    resources: mem_mb = config["gatkRam"], disk_mb = config["gatkDisk"]
    threads: config.get("gatkThreads")
    log:
        "logs/MarkDup/{tumor}.log"
    params:
        mem_gb=lambda wildcards, resources: int(resources.mem_mb) // 1024
    conda:
        "envs/somatic.yaml"
    shell:
        "gatk --java-options -Xmx{params.mem_gb}G MarkDuplicates  -I {input} -O {output.bam} -M {output.metrics}"
