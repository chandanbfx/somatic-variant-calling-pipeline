#!/usr/bin/env python
"""
Optimized Mutect2 wrapper with error handling
"""
from snakemake.shell import shell

# Input validation
assert hasattr(snakemake.input, "tumor"), "Tumor BAM required"
assert hasattr(snakemake.input, "normal"), "Normal BAM required"

cmd = (
    f"gatk --java-options '{snakemake.params.java_opts}' Mutect2 "
    f"-R {snakemake.input.reference} "
    f"-I {snakemake.input.tumor} "
    f"-I {snakemake.input.normal} "
    f"{'-pon ' + snakemake.input.pon if hasattr(snakemake.input, 'pon') else ''} "
    f"-O {snakemake.output.vcf}"
)
shell(f"({cmd}) {snakemake.log}")
