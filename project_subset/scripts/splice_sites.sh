#key directory variables below

DIR=/Volumes/Recovered_Mac/project
analysis="${DIR}"/project_data/analysis/rna_seq
raw_data="${analysis}"/raw-data
genome_dir="${DIR}"/genome_dir
cutadapt="${analysis}"/cutadapt
cutadapt_QC="${analysis}"/QC/cutadapt
FastQ_Screen_Genomes_Path="${genome_dir}"/FastQ_Screen_Genomes
conf_file="${DIR}"/genome_dir/FastQ_Screen_Genomes/fastq_screen.conf
fastqfolder="${analysis}"/QC/fastq-screen
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}")
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

hisat2_extract_splice_sites.py "${genome_dir}"/mouse/Mus_musculus.GRCm38.99.gtf > "${genome_dir}"/mouse/mouse_splice_sites.txt
