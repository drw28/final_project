DIR=/users/dougwicks/documents/biochem/final_year/project

#locations of genome directory, genome download
genome_dir="${DIR}"/analysis/genome_dir
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}")

#specific file location for trimmed reads
rna_seq_data="${DIR}"/analysis/rna_seq/trim_galore

#location of conda source and name of conda environment to run hisat2
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#gunzip the trimmed fq.gz files
gunzip "${rna_seq_data}"/*.fq.gz

#run hisat2 programme to map reads
mkdir "${DIR}"/rna_seq/mapping
hisat2 -x "${genome_dir}"/mouse/"${name}" --known-splicesite-infile "${genome}"/mouse/mouse_splice_sites.txt -p 2 -U "${rna_seq_data}"/*.fq | samtools view -bs - > "${DIR}"/rna_seq/mapping/*.hisat2.bam
