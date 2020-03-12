DIR=/Volumes/Recovered_Mac/project
analysis="${DIR}"/project_data/analysis/hmeDIP-seq
raw_data="${analysis}"/raw-data
genome_dir="${DIR}"/genome_dir
scripts="${DIR}"/project_data/scripts/hmedip
output=$( echo "${name}" | cut -d'.' -f1 )
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}")
fastqfolder="${analysis}"/QC/fastq-scree
FastQ_Screen_Genomes_Path="${genome_dir}"/FastQ_Screen_Genomes
conf_file="${DIR}"/genome_dir/FastQ_Screen_Genomes/fastq_screen.conf
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh
cutadapt_QC="${analysis}"/QC/cutadapt
cutadapt="${analysis}"/cutadapt

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#Make outward directory for fastq files, and run fastq-screen
fastqfolder="${analysis}"/QC/fastq-screen

gzip "${cutadapt}"/*
mkdir "${fastqfolder}"
fastq_screen --conf "${conf_file}" "${cutadapt}"/* -outdir "${fastqfolder}"

#Organise fastq-screen output folders

mkdir -p "${fastqfolder}"/html
mkdir -p "${fastqfolder}"/text
mkdir -p "${fastqfolder}"/png
mv "${fastqfolder}"/*.html "${fastqfolder}"/html
mv "${fastqfolder}"/*.txt "${fastqfolder}"/text
mv "${fastqfolder}"/*.png "${fastqfolder}"/png2
