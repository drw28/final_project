#RUN FASTQC ON RAW DATA

DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project
analysis="${DIR}"/analysis/rna_seq
raw_data="${analysis}"/raw-data

QC="${analysis}"/QC
mkdir -p "${QC}"
mkdir "${QC}"/QC_1

fastqc "${analysis}"/raw-data/* --outdir "${QC}"/QC_1

#organise output files into respective folders
mkdir "${QC}"/QC_1/html
mkdir "${QC}"/QC_1/html

mv "${QC}"/QC_1/*.html "${QC}"/QC_1/html
mv "${QC}"/QC_1/*.fastqc.zip "${QC}"/QC_1/html

#PERFORM ADAPTER AND QUALITY TRIMMING

#create cutadapt and cutadapt_QC folders, for trimmed and QC output
cutadapt="${analysis}"/cutadapt
mkdir -p "${cutadapt}"
cutadapt_QC="${analysis}"/QC/cutadapt
mkdir -p "${cutadapt_QC}"

#location of conda source and name of conda environment to run cutadapt program
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#Insert forward and reverse adapters
fwd_adapter=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
rev_adapter=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

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

#RUN MULTIQC FOR COMPARISON OF RAW-DATA AND trimmed data

multiqc "${analysis}"/QC "${raw_data}" "${cutadapt}"

#FASTQ-SCREEN RUN DUE TO HIGH GC SEQUENCE CONTENT
