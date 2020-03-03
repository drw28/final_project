DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project
conf_file="${DIR}"/scripts/sed_test/fastq_screen.conf
FastQ_Screen_Genomes="${genome_dir}"/FastQ_Screen_Genomes

#Replace [FastQ_Screen_Genomes_Path] with /Users/dougwicks/Documents/Biochem/Final_Year/Project/analysis/genome_dir/FastQ_Screen_Genomes
sed -i'.bu' 's#\[FastQ_Screen_Genomes_Path\]#/Users/dougwicks/Documents/Biochem/Final_Year/Project/analysis/genome_dir/FastQ_Screen_Genomes#' "${conf_file}"
