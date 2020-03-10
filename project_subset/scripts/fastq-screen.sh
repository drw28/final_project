DIR=/Volumes/Recovered_Mac/project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/project_data/analysis/rna_seq
cutadapt="${analysis}"/cutadapt
genome_dir="${DIR}"/genome_dir

fastqfolder="${analysis}"/QC/fastq-screen

#check if indexed genomes already downloaded
FastQ_Screen_Genomes_Path="${genome_dir}"/FastQ_Screen_Genomes
conf_file="${genome_dir}"/FastQ_Screen_Genomes/fastq_screen.conf

if [ -d "${FastQ_Screen_Genomes_Path}" ]
then
  echo "FastQ Genomes already downloaded"
  sed -i'.bu' 's#/Users/dougwicks/Documents/Biochem/Final_Year/Project/analysis/genome_dir/FastQ_Screen_Genomes#/Volumes/Recovered_Mac/project/genome_dir/FastQ_Screen_Genomes#' "${conf_file}"
else
  cd "${genome_dir}"
  fastq_screen --get_genomes
  sed -i'.bu' 's#\[FastQ_Screen_Genomes_Path\]#/Volumes/Recovered_Mac/project/genome_dir/FastQ_Screen_Genomes#' "${conf_file}"
fi

#location of conda source and name of conda environment to run cutadapt program
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#Make outward directory for fastq files, and run fastq-screen
gunzip "${cutadapt}"
mkdir "${fastqfolder}"
fastq_screen --conf "${conf_file}" "${cutadapt}"/CD24Neg_4_*.fq -outdir "${fastqfolder}"
fastq_screen --conf "${conf_file}" "${cutadapt}"/CD24Neg_6_A.fq -outdir "${fastqfolder}"
fastq_screen --conf "${conf_file}" "${cutadapt}"/CD24Neg_8_A.fq -outdir "${fastqfolder}"

#Organise fastq-screen output folders
mkdir -p "${fastqfolder}"/html
mkdir -p "${fastqfolder}"/text
mkdir -p "${fastqfolder}"/png
mv "${fastqfolder}"/*.html "${fastqfolder}"/html
mv "${fastqfolder}"/*.txt "${fastqfolder}"/text
mv "${fastqfolder}"/*.png "${fastqfolder}"/png
