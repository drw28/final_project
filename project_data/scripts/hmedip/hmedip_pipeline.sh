#key directory variables below

DIR=/Volumes/Recovered_Mac/project
analysis="${DIR}"/project_data/analysis/rna_seq
raw_data="${analysis}"/raw-data
genome_dir="${DIR}"/genome_dir

#Make genome and QC folders for organisation
mkdir -p "${genome_dir}"

QC="${analysis}"/QC
mkdir -p "${QC}"
mkdir "${QC}"/QC_1

#Shorten raw-data file names

cd "${raw_data}"
rename 's/_45-U-Neg//' CD24Mid_45-U-Neg*.fq.gz
rename 's/_45-U-Neg//' CD24Neg_45-U-Neg*.fq.gz

#location of conda source and name of conda environment to run bioconda programs
conda_env=final_project
conda_source=/Applications/anaconda3/etc/profile.d/conda.sh

#INITIAL RUN OF FASTQC ON RAW DATA

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

fastqc "${analysis}"/raw-data/* --outdir "${QC}"/QC_1

#organise output files into respective folders
mkdir -p "${QC}"/QC_1/html
mkdir -p "${QC}"/QC_1/fastqc

mv "${QC}"/QC_1/*.html "${QC}"/QC_1/html/
mv "${QC}"/QC_1/*_fastqc.zip "${QC}"/QC_1/fastqc

#PERFORM ADAPTER AND QUALITY TRIMMING

#create cutadapt and cutadapt_QC folders, for trimmed and QC output
cutadapt="${analysis}"/cutadapt
mkdir -p "${cutadapt}"
cutadapt_QC="${analysis}"/QC/cutadapt
mkdir -p "${cutadapt_QC}"

#Insert forward and reverse adapters
fwd_adapter=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
rev_adapter=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

#trim adapters and run fastqc analysis post-trim - currently configured for paired reads (FOUND OUT WAYS TO )
for sample in 1 3 5 7 ; do

  cutadapt --quality-base=64 -q 15 -a "${fwd_adapter}" -A "${rev_adapter}" \
  -o "${cutadapt}"/CD24Mid_"${sample}"_A.fq.gz -p "${cutadapt}"/CD24Mid_"${sample}"_B.fq.gz \
  ${analysis}/raw-data/CD24Mid_"${sample}"_A.fq.gz "${analysis}"/raw-data/CD24Mid_"${sample}"_B.fq.gz > "${cutadapt_QC}"/"${sample}".cutadaptlog

done

for sample in 2 4 6 8 ; do

  cutadapt --quality-base=64 -q 15 -a "${fwd_adapter}" -A "${rev_adapter}" \
  -o "${cutadapt}"/CD24Neg_"${sample}"_A.fq.gz -p "${cutadapt}"/CD24Neg_"${sample}"_B.fq.gz \
  ${analysis}/raw-data/CD24Neg_"${sample}"_A.fq.gz "${analysis}"/raw-data/CD24Neg_"${sample}"_B.fq.gz > "${cutadapt_QC}"/"${sample}".cutadaptlog

done


#RUN SECOND FASTQC ON TRIMMED DATA

fastqc "${cutadapt}"/*

#organise output files into folders
mkdir -p "${cutadapt_QC}"/html
mkdir -p "${cutadapt_QC}"/fastqc.zip

mv "${cutadapt}"/*.html "${cutadapt_QC}"/html
mv "${cutadapt}"/*_fastqc.zip "${cutadapt_QC}"/fastqc.zip

#RUN MULTIQC FOR COMPARISON OF RAW-DATA AND TRIMMED DATA - NOT SURE ABOUT THIS!!!

#activate base environment
conda activate

multiqc -f "${analysis}"

mkdir "${QC}"/multiqc_data
mv ./multiqc_data/* "${QC}"/multiqc_data
rm -r ./multiqc_data
mv ./multiqc_report.html "${QC}"

#FASTQ-SCREEN RUN DUE TO HIGH GC SEQUENCE CONTENT

#check if indexed genomes already downloaded
FastQ_Screen_Genomes_Path="${genome_dir}"/FastQ_Screen_Genomes
conf_file="${DIR}"/genome_dir/FastQ_Screen_Genomes/fastq_screen.conf

if [ -d "${FastQ_Screen_Genomes_Path}" ]
then
  echo "FastQ Genomes already downloaded"
  sed -i'.bu' 's#/Users/dougwicks/Documents/Biochem/Final_Year/Project/analysis/genome_dir/FastQ_Screen_Genomes#/Volumes/Recovered_Mac/project/genome_dir/FastQ_Screen_Genomes#' "${conf_file}"
else
  cd "${genome_dir}"
  fastq_screen --get_genomes
  sed -i'.bu' 's#\[FastQ_Screen_Genomes_Path\]#/Volumes/Recovered_Mac/project/genome_dir/FastQ_Screen_Genomes#' "${conf_file}"
fi

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#Make outward directory for fastq files, and run fastq-screen
fastqfolder="${analysis}"/QC/fastq-screen

gunzip "${cutadapt}"/*
mkdir "${fastqfolder}"
fastq_screen --conf "${conf_file}" "${cutadapt}"/*.fq -outdir "${fastqfolder}"

#Organise fastq-screen output folders

mkdir -p "${fastqfolder}"/html
mkdir -p "${fastqfolder}"/text
mkdir -p "${fastqfolder}"/png
mv "${fastqfolder}"/*.html "${fastqfolder}"/html
mv "${fastqfolder}"/*.txt "${fastqfolder}"/text
mv "${fastqfolder}"/*.png "${fastqfolder}"/png

#ADD MOUSE GENOME - make this and index genome a separate script which can run from here if genome files not present

#insert location of genome for download within quotation marks
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"
name=$(basename "${genome}")
gzipped_name="${genome_dir}"/mouse/Mus_musculus.GRCm38.dna.primary_assembly.fa

mkdir "${genome_dir}"/mouse

if [ -a "${genome_dir}"/mouse/"${name}" || "${gzipped_name}" ]
then
  echo "Genomes already downloaded"
else
  curl "${genome}" > "${genome_dir}"/mouse/"${name}"
fi

#INDEX MOUSE GENOME - LINE 128 IN RNA PIPELINE 1

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

output=$( echo "${name}" | cut -d'.' -f1 )

#first gunzip reference genome
gunzip "${genome_dir}"/mouse/"${name}"

#index using hisat2-build from gunzipped file, caffeinate run to prevent mac going to sleep overnight
cd "${DIR}"

zip "${genome_dir}"/mouse/*.gz

if [ -a "${genome_dir}"/mouse/Mus_musculus.8.ht2 ]
then
  echo "Genome already indexed"
else
  caffeinate hisat2-build -f "${genome_dir}"/mouse/"${name/.gz}" "${genome_dir}"/mouse/"${output}"
fi

#MAP READS

mkdir "${analysis}"/mapping

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#make mapping directory, gunzip fq.gz files run hisat2 programme to map reads, output hisat2 mapping stats into a text files
gunzip "${cutadapt}"/*.gz
hisat2_extract_splice_sites.py "${genome_dir}"/mouse/Mus_musculus.GRCm38.99.gtf > "${genome_dir}"/mouse/mouse_splice_sites.txt

for sample in 1 3 5 7 ; do

  hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome_dir}"/mouse/mouse_splice_sites.txt \
  -p 2 -1 "${cutadapt}"/CD24Mid_"${sample}"_A* -2 "${cutadapt}"/CD24Mid_"${sample}"_B* \
  --summary-file "${analysis}"/mapping/CD24Mid_"${sample}"_hisat2_mapping.txt \
  | samtools view -bS - > "${analysis}"/mapping/CD24Mid_"${sample}".hisat.bam

done

for sample in 2 4 6 8 ; do

  hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome_dir}"/mouse/mouse_splice_sites.txt \
  -p 2 -1 "${cutadapt}"/CD24Neg_"${sample}"_A* -2 "${cutadapt}"/CD24Neg_"${sample}"_B* \
  --summary-file "${analysis}"/mapping/CD24Neg_"${sample}"_hisat2_mapping.txt \
  | samtools view -bS - > "${analysis}"/mapping/CD24Neg_"${sample}".hisat.bam

done

mkdir -p "${analysis}"/mapping/txt
mv "${analysis}"/mapping/*.txt "${analysis}"/mapping/txt

#RUN MULTIQC TO GET SUMMARY STATS ON mapping

mkdir -p "${QC}"/hisat2_mapping
multiqc -f "${analysis}"/mapping

mv ./multiqc_data/* "${QC}"/hisat2_mapping/
rm -r ./multiqc_data
mv ./multiqc_report.html "${QC}"/hisat2_mapping/
