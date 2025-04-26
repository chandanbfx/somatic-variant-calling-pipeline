# 🧬 Somatic Variants Calling Pipeline

This repository contains a modular, Snakemake-based pipeline to perform somatic variant calling from matched tumor-normal BAM files, following GATK best practices. It is designed to be scalable, reproducible, and easy to configure for different datasets.

---

## 📁 Project Structure

```
.
├── config/                 # Configuration files (sample sheet, config.yaml)
├── data/                   # Tumor and normal BAMs (input files)
├── database/               # Variant databases (e.g., dbSNP, ClinVar)
├── envs/                   # Conda environment YAML files
├── reference/              # Reference genome
├── resources/              # Resource files (PON, AF, Funcotator, etc.)
├── rules/                  # Modular Snakemake rules
├── scripts/                # Python or shell scripts
├── chr17plus.interval_list# BED/interval list for test runs
├── Snakefile               # Main pipeline entry
└── README.md               # Project documentation
```

---

## ⚙️ Requirements

- [Snakemake](https://snakemake.readthedocs.io/en/stable/) ≥ 7.x
- [Conda](https://docs.conda.io/en/latest/)
- Python ≥ 3.7
- Unix-based system

---

## 📥 Input Files

### 1. Sample Sheet

Path: `config/samples.tsv`

**TSV format** (tab-separated):

```
sample_id	sample_type	bam_prefix	normal_name
HCC1144_tumor	tumor	data/HCC1144_T_clean	-
HCC1144_normal	normal	data/HCC1144_N_clean	HCC1144_BL
HCC1143_tumor	tumor	data/hcc1143_T_clean	-
HCC1143_normal	normal	data/hcc1143_N_clean	HCC1143_BL
```

- `bam_prefix` should point to the BAM file (without `.bam`).
- Ensure tumor-normal pairing is consistent.

### 2. Config File

Path: `config.yaml`

Includes references to all inputs, resource allocations, database paths, and file structure.

---

## 📦 Required Reference & Resource Files

These are **not included in the repository** due to their size. Please download manually and place in the correct directories.

### 🔬 Reference Genome (put in `reference/`)

- Example file: `chr1.fa`
- [Download GRCh38](https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome.fa)

### 🧬 Variant Databases (put in `database/`)

- dbSNP: [Download](https://ftp.ncbi.nih.gov/snp/latest_release/VCF/)
- ClinVar: [Download](https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/)

Make sure you include `.tbi` index files for each VCF.

### 🧰 Additional Resources (put in `resources/`)

- gnomAD AF: [Download](https://storage.googleapis.com/gatk-best-practices/somatic-hg38/af-only-gnomad.hg38.vcf.gz)
- 1000G PON: [Download](https://storage.googleapis.com/gatk-best-practices/somatic-hg38/1000g_pon.hg38.vcf.gz)
- ExAC: [Download](https://.../exac) *(add URL as needed)*
- Funcotator data sources:
  [Download v1.8 hg38](https://gatk.broadinstitute.org/hc/en-us/articles/360035890811)

> 📌 **Note**: Ensure all `.vcf.gz` files are indexed with `.tbi` and placed in the correct folders.

---

## ▶️ Running the Workflow

### 1. Dry Run (sanity check)

```bash
snakemake -n
```

### 2. Execute on 16 cores with Conda

```bash
snakemake --use-conda --cores 16
```

> 🔄 Conda environments are defined in the `envs/` directory and will be auto-created.

---

## 📤 Output Overview

- `sorted_reads/`: BAMs sorted by queryname and coordinate, adapter-marked and duplicate-removed
- `logs/`: Log files for each processing step
- `raw_variants/`: Mutect2 raw VCFs and stats
- `analysis_ready/`: Recalibrated BAMs ready for variant calling

---

## 🧾 Acknowledgements

This pipeline integrates multiple best-in-class bioinformatics tools:

- [GATK (Broad Institute)](https://gatk.broadinstitute.org/)
- [Snakemake (Köster Lab)](https://snakemake.readthedocs.io/)
- [Funcotator](https://gatk.broadinstitute.org/hc/en-us/articles/360037594811)
- [samtools](http://www.htslib.org/)
- [bcftools](http://samtools.github.io/bcftools/)
- [BEDTools](https://bedtools.readthedocs.io/en/latest/)
- [Python](https://www.python.org/)
- [Conda](https://docs.conda.io/)

Special thanks to the open-source community for maintaining these tools and databases.

---

## 🧪 Citation

If you use this pipeline in your research, please cite the underlying tools (Snakemake, GATK, etc.) and this repository where appropriate.

---

## 🤝 Contributions

Contributions are welcome! Feel free to open issues or submit pull requests for improvements, bug fixes, or new features.

---

## 📬 Contact

If you encounter issues or need help setting up the workflow, feel free to open an [issue](https://github.com/chndanbfx/somatic-variantsCalling-pipeline/issues) or contact the maintainer.
