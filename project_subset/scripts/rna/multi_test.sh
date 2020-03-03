DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

#locations of genome directory, genome download
genome_dir="${DIR}"/analysis/genome_dir
analysis="${DIR}"/analysis/rna_seq
QC="${analysis}"/QC

mkdir -p "${QC}"/hisat2_mapping

multiqc -f "${analysis}"/mapping
mv multiqc_data "${QC}"/hisat2_mapping/
mv multiqc_report.html "${QC}"/hisat2_mapping/
