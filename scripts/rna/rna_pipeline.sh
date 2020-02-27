#key variables below

DIR=/Volumes/Recovered_Mac/Project
analysis="${DIR}"/analysis/rna_seq
raw_data="${analysis}"/raw-data

QC="${analysis}"/QC
mkdir -p "${QC}"
mkdir "${QC}"/QC_1

#location of conda source and name of conda environment to run bioconda programs
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#RUN FASTQC ON RAW DATA
fastqc "${analysis}"/raw-data/* --outdir "${QC}"/QC_1

#organise output files into respective folders
mkdir "${QC}"/QC_1/html
mkdir "${QC}"/QC_1/fastqc.zip

mv "${QC}"/QC_1/*.html "${QC}"/QC_1/html
mv "${QC}"/QC_1/*.fastqc.zip "${QC}"/QC_1/fastc.zip

#PERFORM ADAPTER AND QUALITY TRIMMING

#create cutadapt and cutadapt_QC folders, for trimmed and QC output
cutadapt="${analysis}"/cutadapt
mkdir -p "${cutadapt}"
cutadapt_QC="${analysis}"/QC/cutadapt
mkdir -p "${cutadapt_QC}"

#Insert forward and reverse adapters
fwd_adapter=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
rev_adapter=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

#trim adapters and run fastqc analysis post-trim - currently configured for paired reads
for sample in 1 2 3 4 5 6 7 8 ; do

cutadapt --quality-base=64 -q 15 -a "${fwd_adapter}" -A "${rev_adapter}" \
-o "${cutadapt}"/"${sample}"_A-subset.fq.gz -p "${cutadapt}"/"${sample}"_B-subset.fq.gz \
${analysis}/raw-data/*_"${sample}"_A-subset.fq.gz "${analysis}"/raw-data/*_"${sample}"_B-subset.fq.gz > "${cutadapt_QC}"/"${sample}".cutadaptlog

done

#RUN SECOND FASTQC ON TRIMMED DATA

fastqc "${cutadapt}"/*

#organise output files into folders
mkdir -p "${cutadapt_QC}"/html
mkdir -p "${cutadapt_QC}"/fastqc.zip

mv "${cutadapt}"/*.html "${cutadapt_QC}"/html
mv "${cutadapt}"/*fastqc.zip "${cutadapt_QC}"/fastqc.zip

#RUN MULTIQC FOR COMPARISON OF RAW-DATA AND TRIMMED DATA - NOT SURE ABOUT THIS!!!

#activate base environment, run multiqc, and organise output files
conda activate

multiqc -f "${analysis}"

mkdir "${QC}"/multiqc_data

cp -rl ./multiqc_data "${QC}"
rm -r ./multiqc_data
mv ./multiqc_report.html "${QC}"

#FASTQ-SCREEN RUN DUE TO HIGH GC SEQUENCE CONTENT

#ADD GENOME

#INDEX GENOME

#MAP READS

#locations and basenaming of genome
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}" | cut -d'.' -f1)

mkdir "${DIR}"/analysis/rna_seq/mapping

#make mapping directory, gunzip fq.gz files run hisat2 programme to map reads, output hisat2 mapping stats into a text files
gunzip "${cutadapt}"/*.gz

for sample in 1 2 3 4 5 6 7 8 ; do

hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome}"/mouse/mouse_splice_sites.txt \
-p 2 -1 "${cutadapt}"/"${sample}"_A-subset* -2 "${cutadapt}"/"${sample}"_B-subset* \ 2> "${DIR}"/analysis/rna_seq/mapping/mapping_stats.txt.gz
| samtools view -bS - > "${DIR}"/analysis/rna_seq/mapping/"${sample}".hisat.bam

done
