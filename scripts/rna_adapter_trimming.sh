DIR=/Users/dougwicks/Documents/Biochem/Final_Year/Project

#alter line 4 file path depending RNA/HMEdip-seq
analysis="${DIR}"/analysis/rna_seq
QC_2="${analysis}"/QC_2
mkdir -p "${QC_2}"

#trim adapters and run fastqc analysis post-trim
trim_galore --fastqc ${analysis}/raw-data/* -o "${QC_2}"

#organise output files into folders
mkdir -p "${QC_2}"/html
mkdir -p "${QC_2}"/fastqc.zip
mkdir -p "${QC_2}"/fq.gz
mkdir -p "${QC_2}"/text

mv "${QC_2}"/*.html "${QC_2}"/html
mv "${QC_2}"/*fastqc.zip "${QC_2}"/fastqc.zip
mv "${QC_2}"/*.fq.gz "${QC_2}"/fq.gz
mv "${QC_2}"/*.txt "${QC_2}"/text
