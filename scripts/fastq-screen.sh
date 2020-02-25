DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/rna_seq
cutadapt="${analysis}"/cutadapt
fastqfolder="${analysis}"/QC/fastq-screen
genome_dir="${DIR}"/analysis/genome_dir

#location of fastq_screen and conf files: /Applications/anaconda3/envs/final_project/share/fastq-screen-0.13.0-1/fastq_screen.conf
genome_dir="${DIR}"/analysis/genome_dir
"${genome_dir}" fastq_screen --get_genomes



#location of conda source and name of conda environment to run cutadapt program
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#Make outward directory for fastq files, and run fastq-screen
mkdir "${fastqfolder}"
fastq_screen --conf  "${cutadapt}"/*.fq -outdir "${fastqfolder}"
