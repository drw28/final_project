DIR=/Volumes/Recovered_Mac/project
genome_dir="${DIR}"/genome_dir
FastQ_Genomes_Path="${genome_dir}"/FastQ_Screen_Genomes

#location of conda source and name of conda environment to run cutadapt program
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

gzip "${genome_dir}"/mouse/*.gz

if [ -a "${genome_dir}"/mouse/Mus_musculus.8.ht2 ]
then
  echo "Genome already indexed"
else
  caffeinate hisat2-build -f "${genome_dir}"/mouse/"${name/.gz}" "${output}"
fi
