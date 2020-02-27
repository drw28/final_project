DIR=/Volumes/Recovered_Mac/project

#locations of genome directory, genome download
genome_dir="${DIR}"/analysis/genome_dir
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}" | cut -d'.' -f1)

#specific file location for trimmed reads
cutadapt="${DIR}"/analysis/rna_seq/cutadapt

#location of conda source and name of conda environment to run hisat2
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#make mapping directory, gunzip fq.gz files run hisat2 programme to map reads, output hisat2 mapping stats into a text files
mkdir "${DIR}"/analysis/rna_seq/mapping

gunzip "${cutadapt}"/*.gz

for sample in 1 2 3 4 5 6 7 8 ; do

hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome}"/mouse/mouse_splice_sites.txt \
-p 2 -1 "${cutadapt}"/"${sample}"_A-subset* -2 "${cutadapt}"/"${sample}"_B-subset* \ 2> "${DIR}"/analysis/rna_seq/mapping/mapping_stats.txt.gz
| samtools view -bS - > "${DIR}"/analysis/rna_seq/mapping/"${sample}".hisat.bam

done
