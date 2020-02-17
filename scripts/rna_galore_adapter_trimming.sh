DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/rna_seq
trim_galore2="${analysis}"/trim_galore2
mkdir -p "${trim_galore2}"

#location of conda source and name of conda environment to run Trim Galore! program
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#trim adapters and run fastqc analysis post-trim
trim_galore --illumina --fastqc --quality 20 ${analysis}/raw-data/* -o "${trim_galore2}"

#organise output files into folders
mkdir -p "${trim_galore2}"/html
mkdir -p "${trim_galore2}"/fastqc.zip
mkdir -p "${trim_galore2}"/fq.gz
mkdir -p "${trim_galore2}"/text

mv "${trim_galore2}"/*.html "${trim_galore2}"/html
mv "${trim_galore2}"/*fastqc.zip "${trim_galore2}"/fastqc.zip
mv "${trim_galore2}"/*.fq.gz "${trim_galore2}"/fq.gz
mv "${trim_galore2}"/*.txt "${trim_galore2}"/text
