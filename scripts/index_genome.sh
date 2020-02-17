DIR=/users/dougwicks/documents/biochem/final_year/project

#locations of genome directory, genome download
genome_dir="${DIR}"/analysis/genome_dir
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}")

#location of conda source and name of conda environment to run hisat2
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

output=$( echo "${name}" | cut -d'.' -f1 )

#unzip reference genome and index using hisat2, caffeinate run to prevent mac going to sleep overnight
caffeinate
hisat2-build -f "${genome_dir}"/"${name}" "${output}"

#move output files into genome folder
mv "${DIR}"/*.ebwt "${genome_dir}"
