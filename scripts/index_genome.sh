DIR=/Volumes/Recovered_Mac/project

#locations of genome directory, genome download
genome_dir="${DIR}"/analysis/genome_dir/human
genome="/Volumes/Recovered_Macproject/analysis/genome_dir/human/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}")

#location of conda source and name of conda environment to run hisat2
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

output=$( echo "${name}" | cut -d'.' -f1 )

#first gunzip reference genome
gunzip "${genome_dir}"/"${name}"

#index using hisat2-build from gunzipped file, caffeinate run to prevent mac going to sleep overnight
caffeinate hisat2-build -f "${genome_dir}"/"${name/.gz}" "${output}"

#move output files into genome folder
mv "${DIR}"/*.ebwt "${genome_dir}"
