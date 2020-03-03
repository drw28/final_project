DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/hmeDIP_seq
trim_galore="${analysis}"/trim_galore
mkdir -p "${trim_galore}"

#location of conda source and name of conda environment to run Trim Galore! program
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#trim adapters and run fastqc analysis post-trim
trim_galore --fastqc ${analysis}/raw-data/* -o "${trim_galore}"

#organise output files into folders
mkdir -p "${trim_galore}"/html
mkdir -p "${trim_galore}"/fastqc.zip
mkdir -p "${trim_galore}"/fq.gz
mkdir -p "${trim_galore}"/text

mv "${trim_galore}"/*.html "${trim_galore}"/html
mv "${trim_galore}"/*fastqc.zip "${trim_galore}"/fastqc.zip
mv "${trim_galore}"/*.fq.gz "${trim_galore}"/fq.gz
mv "${trim_galore}"/*.txt "${trim_galore}"/text
