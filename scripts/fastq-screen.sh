DIR=/Volumes/Recovered_Mac/Project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/rna_seq
cutadapt="${analysis}"/cutadapt
genome_dir="${DIR}"/analysis/genome_dir

fastqfolder="${analysis}"/QC/fastq-screen
genomes_path=/Volumes/Recovered_Mac/Project/analysis/genome_dir/FastQ_Screen_Genomes
conf_file=/Volumes/Recovered_Mac/Project/analysis/genome_dir/FastQ_Screen_Genomes/fastq_screen.conf

#location of fastq_screen files: /Applications/anaconda3/envs/final_project/share/fastq-screen-0.13.0-1/fastq_screen.conf
genome_dir="${DIR}"/analysis/genome_dir
cd "${genome_dir}" ; fastq_screen --get_genomes

#NEED TO INSERT SED COMMAND TO INSERT CORRECT FOLDER PATH INTO CONFIGURATIONS FILE

INSERT THE SED COMMAND SOMEHOW

#location of conda source and name of conda environment to run cutadapt program
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#Make outward directory for fastq files, and run fastq-screen
mkdir "${fastqfolder}"
fastq_screen --conf "${conf_file}" "${cutadapt}"/*.fq -outdir "${fastqfolder}"

#Organise fastq-screen output folders
mkdir "${fastqfolder}"/html "${fastqfolder}"/text "${fastqfolder}"/png
mv "${fastqfolder}"/*.html "${fastqfolder}"/html
mv "${fastqfolder}"/*.txt "${fastqfolder}"/text
mv "${fastqfolder}"/*.png "${fastqfolder}"/png
