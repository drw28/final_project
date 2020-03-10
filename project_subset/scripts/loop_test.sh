DIR=/Volumes/Recovered_Mac/project
analysis="${DIR}"/project_data/analysis/rna_seq
test_data="${analysis}"/raw-test

group="${file/*_[AB].fq.gz/}"
read1="${file}"
read2="${file/A.fq.gz/B.fq.gz}"

for file in 1 2 3 4 5 6 7 8 ; do
  
  group="${file/*_[AB].fq.gz/}"
  read1="${file}"
  read2="${file/A.fq.gz/B.fq.gz}"

  echo "${read1}" "${read2}"
  echo "${group}"

done
