DIR=/Volumes/Recovered_Mac/project
conf_file="${DIR}"/project_subset/scripts/sed_test/fastq_screen.conf
genome_dir="${DIR}"/genome_dir
FastQ_Screen_Genomes="${genome_dir}"/FastQ_Screen_Genomes

#Replace [FastQ_Screen_Genomes_Path] with /Users/dougwicks/Documents/Biochem/Final_Year/Project/analysis/genome_dir/FastQ_Screen_Genomes
sed -i'.bu' 's#/Users/dougwicks/Documents/Biochem/Final_Year/Project/analysis/genome_dir/FastQ_Screen_Genomes#/Volumes/Recovered_Mac/project/genome_dir/FastQ_Screen_Genomes#' "${conf_file}"
