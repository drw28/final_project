DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

analysis="${DIR}"/analysis/rna_seq

QC="${analysis}"/QC
mkdir -p "${QC}"

fastqc "${analysis}"/raw-data/* --outdir "${QC}"
