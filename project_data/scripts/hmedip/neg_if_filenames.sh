#key directory variables below

DIR=/Volumes/Recovered_Mac/project
analysis="${DIR}"/project_data/analysis/hmeDIP-seq
raw_data="${analysis}"/raw-data
genome_dir="${DIR}"/genome_dir


#Neg cells - samples 2/3/5/7/8
rename 's/.927.s_1.r_1/-neg/' "${raw_data}"/2Bound.927.s_1.r_1.fq.gz
rename 's/.927.s_1.r_1/-neg/' "${raw_data}"/3Bound.927.s_1.r_1.fq.gz
rename 's/.927.s_1.r_1/-neg/' "${raw_data}"/5Bound.927.s_1.r_1.fq.gz
rename 's/.927.s_2.r_1/-neg/' "${raw_data}"/5Input.927.s_2.r_1.fq.gz
rename 's/.927.s_2.r_1/-neg/' "${raw_data}"/7Bound.927.s_2.r_1.fq.gz
rename 's/.927.s_2.r_1/-neg/' "${raw_data}"/8Bound.927.s_2.r_1.fq.gz
