DIR=/Volumes/Recovered_Mac/project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/rna_seq
cutadapt="${analysis}"/cutadapt
genome_dir="${DIR}"/analysis/genome_dir

fastqfolder="${analysis}"/QC/fastq-screen
genomes_path="${DIR}"/analysis/genome_dir/FastQ_Screen_Genomes
conf_file="${DIR}"/analysis/genome_dir/FastQ_Screen_Genomes/fastq_screen.conf

#location of fastq_screen files: /Applications/anaconda3/envs/final_project/share/fastq-screen-0.13.0-1/fastq_screen.conf, Sed command inputs correct genomes directory
genome_dir="${DIR}"/analysis/genome_dir

if [ -a "${genomes_path}" ]
then
  echo "Genomes already downloaded"
else
  cd "${genome_dir}"
  fastq_screen --get_genomes
  sed -i'.bu' 's#\[FastQ_Screen_Genomes_Path\]#/Users/dougwicks/Documents/Biochem/Final_Year/Project/analysis/genome_dir/FastQ_Screen_Genomes#' "${conf_file}"
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
fastq_screen --conf "${conf_file}" "${cutadapt}"/*.fq -outdir "${fastqfolder}"

#Organise fastq-screen output folders
mkdir "${fastqfolder}"/html "${fastqfolder}"/text "${fastqfolder}"/png
mv "${fastqfolder}"/*.html "${fastqfolder}"/html
mv "${fastqfolder}"/*.txt "${fastqfolder}"/text
mv "${fastqfolder}"/*.png "${fastqfolder}"/png
