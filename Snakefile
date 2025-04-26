configfile: "config/config.yaml"

import pandas as pd

# Load TSV file from path in config
samples_df = pd.read_csv(config["sample_sheet"], sep="\t")

print(samples_df.head())

# Separate normal and tumor
normal_samples = samples_df[samples_df['sample_type'] == 'normal']
tumor_samples = samples_df[samples_df['sample_type'] == 'tumor']

# Build dictionaries: {sample_id: bam_prefix}
config["normal"] = {row['sample_id']: row['bam_prefix'] for _, row in normal_samples.iterrows()}
config["tumor"] = {row['sample_id']: row['bam_prefix'] for _, row in tumor_samples.iterrows()}

# Store sample IDs for wildcards
config["normal_ids"] = list(config["normal"].keys())
config["tumor_ids"] = list(config["tumor"].keys())

# Extract normal sample names for Mutect2 labeling
normal_names_list = normal_samples["normal_name"].tolist()
normal_names_cleaned = [name for name in normal_names_list if name.strip() and name.strip() != "-"]
config["normal_names"] = normal_names_cleaned

# Debug prints
print("Normal:", config["normal"])
print("Tumor:", config["tumor"])
print("Normal IDs:", config["normal_ids"])
print("Tumor IDs:", config["tumor_ids"])
print("Normal names (for mutect2):", config["normal_names"])


# Include all rule files
include: "rules/preprocessing.smk"
include: "rules/alignment_processing.smk"
include: "rules/core_calling.smk"
include: "rules/filtering.smk"
include: "rules/annotation.smk"
include: "rules/utilities.smk"

rule all:
    input:
        expand("annotation/{tumor}.AnnFun_clinVar.vcf.gz", tumor=config["tumor_ids"]),
        expand("annotation/{tumor}.AnnFun_dbSNP.vcf.gz", tumor=config["tumor_ids"]),
        "variants/Allvcf_stats.txt"
