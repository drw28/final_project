#YOU DID NOT NEED TO DO THIS AS FASTQ-SCREEN REQUIRES BOWTIE INDEXXED GENOMES - NOT HISAT2

DIR=/users/dougwicks/documents/biochem/final_year/project

#locations of genome directory, genome download across all species, plus names for ouput files
genome_dir="${DIR}"/analysis/genome_dir
human_genome="/Users/dougwicks/Documents/Biochem/Final_Year/project/analysis/genome_dir/human/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
human_name=$(basename "${human_genome}")
rat_genome="/Users/dougwicks/Documents/Biochem/Final_Year/project/analysis/genome_dir/rat/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz"
rat_name=$(basename "${rat_genome}")
yeast_genome="/Users/dougwicks/Documents/Biochem/Final_Year/project/analysis/genome_dir/yeast/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"
yeast_name=$(basename "${yeast_genome}")

#location of conda source and name of conda environment to run hisat2
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#sort output names
human_output=$( echo "${human_name}" | cut -d'.' -f1 )
rat_output=$( echo "${rat_name}" | cut -d'.' -f1 )
yeast_output=$( echo "${yeast_name}" | cut -d'.' -f1 )

#gunzip all genomes to be indexed
gunzip "${genome_dir}"/human/"${human_name}"
gunzip "${genome_dir}"/rat/"${rat_name}"
gunzip "${genome_dir}"/yeast/"${yeast_name}"

#index using hisat2-build from gunzipped file, caffeinate run to prevent mac going to sleep overnight, specify genome_dir output
caffeinate hisat2-build -f "${genome_dir}"/human/"${human_name/.gz}" "${genome_dir}"/human/"${human_output}"
caffeinate hisat2-build -f "${genome_dir}"/rat/"${rat_name/.gz}" "${genome_dir}"/rat/"${rat_output}"
caffeinate hisat2-build -f "${genome_dir}"/yeast/"${yeast_name/.gz}" "${genome_dir}"/yeast/"${yeast_output}"
