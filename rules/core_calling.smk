"""
Core somatic variant calling with Mutect2
"""

rule mutect2:
    input:
        tumor=expand("Analysis_ready/tumor/Recalibrated_processed_{tumor}.bam", tumor=config["tumor_ids"]),
        normal=expand("Analysis_ready/normal/Recalibrated_processed_{normal}.bam", normal=config["normal_ids"]),
        reference=config["reference"],
        pon=config["crsp"],
        germline=config["af"],
        intervals=config["bedfile"]
    output:
        vcf="raw_variants/all.rawvcf.gz",
        f1r2="raw_variants/all.f1r2.tar.gz",
        stats="raw_variants/all.rawvcf.gz.stats"
    params:
        extra="--f1r2-tar-gz {output.f1r2}"\
        "--native-pair-hmm-threads 15 ",
        normal_names=" ".join([f"-normal {name}" for name in config["normal_names"]])
    resources: mem_mb = config["gatkRam"], disk_mb = config["gatkDisk"]
    threads: config.get("gatkThreads")
    log:
        "logs/mutect2/joint_call.log"
    conda:
        "env/somatic.yaml"
    script:
        "../scripts/wrapper.py"
