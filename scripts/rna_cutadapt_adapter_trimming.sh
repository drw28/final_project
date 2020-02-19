DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/rna_seq
cutadapt="${analysis}"/cutadapt
mkdir -p "${cutadapt}"

#make cutadapt QC folder
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

#trim adapters and run fastqc analysis post-trim
for sample in 1 2 3 4 5 6 7 8 ; do

cutadapt -q 15 -a "${fwd_adapter}" -A "${rev_adapter}" \
-o "${cutadapt}"/"${sample}"_A-subset.fq.gz -p "${cutadapt}"/"${sample}"_B-subset.fq.gz \
${analysis}/raw-data/*_"${sample}"_A-subset.fq.gz "${analysis}"/raw-data/*_"${sample}"_B-subset.fq.gz 2> "${cutadapt_QC}"/"${sample}".cutadaptlog

done

#run fast qc
fastqc "${cutadapt}"/*

#organise output files into folders
mkdir -p "${cutadapt_QC}"/html
mkdir -p "${cutadapt_QC}"/fastqc.zip
mkdir -p "${cutadapt_QC}"/fq.gz

mv "${cutadapt}"/*.html "${cutadapt_QC}"/html
mv "${cutadapt}"/*fastqc.zip "${cutadapt_QC}"/fastqc.zip
mv "${cutadapt}"/*.fq.gz "${cutadapt_QC}"/fq.gzcu
