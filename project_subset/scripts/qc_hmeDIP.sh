DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

analysis="${DIR}"/analysis/hmeDIP-seq

QC="${analysis}"/QC
mkdir -p "${QC}"

fastqc "${analysis}"/raw-data/* --outdir "${QC}"
