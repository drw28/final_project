DIR=/users/dougwicks/documents/biochem/final_year/project

#locations of genome directory, genome download
genome_dir="${DIR}"/analysis/genome_dir

#location of conda source and name of conda environment to run hisat2
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#gunzip splice sites file
gunzip "${genome_dir}"/mouse/Mus_musculus.GRCm38.99.gtf.gz

#run hisat2 command to summarise all known mouse splice sites into a single txt file
hisat2_extract_splice_sites.py "${genome_dir}"/mouse/Mus_musculus.GRCm38.99.gtf > "${genome_dir}"/mouse/mouse_splice_sites.txt
