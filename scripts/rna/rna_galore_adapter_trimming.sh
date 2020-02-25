DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/rna_seq
cutadapt="${analysis}"/cutadapt
mkdir -p "${cutadapt}"

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
for sample in 1 2; do

cutadapt -a "${fwd_adapter}" -A "${rev_adapter}" \
-o "${cutadapt}"/*"${sample}"_A-subset.fq.gz -p "${cutadapt}"/*"${sample}"_B-subset.fq.gz \
${analysis}/raw-data/*A-subset.fq.gz ${analysis}/raw-data/*B-subset.fq.gz

done

fastqc "${cutadapt}"/*

#organise output files into folders
mkdir -p "${cutadapt}"/html
mkdir -p "${cutadapt}"/fastqc.zip
mkdir -p "${cutadapt}"/fq.gz
mkdir -p "${cutadapt}"/text

mv "${cutadapt}"/*.html "${cutadapt}"/html
mv "${cutadapt}"/*fastqc.zip "${cutadapt}"/fastqc.zip
mv "${cutadapt}"/*.fq.gz "${cutadapt}"/fq.gz
mv "${cutadapt}"/*.txt "${cutadapt}"/text
