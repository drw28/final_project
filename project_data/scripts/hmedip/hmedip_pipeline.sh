#key directory variables below

DIR=/Volumes/Recovered_Mac/project
analysis="${DIR}"/project_data/analysis/hmeDIP-seq
raw_data="${analysis}"/raw-data
genome_dir="${DIR}"/genome_dir
scripts="${DIR}"/project_data/scripts/hmedip
QC="${analysis}"/QC

#Make genome and QC folders for organisation
mkdir -p "${genome_dir}"

mkdir -p "${QC}"
mkdir "${QC}"/QC_1

#Merge "_p2" file names using 'for' loop - CHECK THIS
bash "${scripts}"/merge_test.sh

#ALTER FILENAMES TO CORRECTLY CAPTURE MID/NEG CELLS
#mid-cells
if [ -a "${raw_data}"/1*-mid* ] && [ -a "${raw_data}"/4*-mid* ] && [ -a "${raw_data}"/6*-mid* ] ; then
  echo "filenames already altered"
else
  bash "${scripts}"/mid_if_filenames.sh
fi

#neg-cells
if [ -a "${raw_data}"/2*-neg* ] && [ -a "${raw_data}"/3*-neg* ] && [ -a "${raw_data}"/5*-neg* ] && \
[ -a "${raw_data}"/7*-neg* ] && [ -a "${raw_data}"/8*-neg* ] ; then
  echo "filenames already altered"
else
  bash "${scripts}"/neg_if_filenames.sh
fi

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

#mid-cells cutadapt for loop + input control
for sample in 1 4 6 ; do

  cutadapt --quality-base=64 -q 15 -a "${fwd_adapter}" -j 0 -o "${cutadapt}"/"${sample}"Bound-mid_trim.fq.gz \
  ${analysis}/raw-data/"${sample}"Bound-mid.fq.gz > "${cutadapt_QC}"/"${sample}"Bound-mid.cutadaptlog

done

cutadapt --quality-base=64 -q 15 -a "${fwd_adapter}" -j 0 -o "${cutadapt}"/4Input-mid_trim.fq.gz \
${analysis}/raw-data/4Input-mid.fq.gz > "${cutadapt_QC}"/4Input-mid.cutadaptlog

#neg-cells cutadapt for loop + input control
for sample in 2 3 5 7 8 ; do

  cutadapt --quality-base=64 -q 15 -a "${fwd_adapter}" -j 0 -o "${cutadapt}"/"${sample}"Bound-neg_trim.fq.gz \
  ${analysis}/raw-data/"${sample}"Bound-neg.fq.gz > "${cutadapt_QC}"/"${sample}"Bound-neg.cutadaptlog

done

cutadapt --quality-base=64 -q 15 -a "${fwd_adapter}" -j 0 -o "${cutadapt}"/5Input-neg_trim.fq.gz \
${analysis}/raw-data/5Input-neg.fq.gz > "${cutadapt_QC}"/5Input-neg.cutadaptlog

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
fastq_screen --conf "${conf_file}" "${cutadapt}"/* -outdir "${fastqfolder}"

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

mkdir "${genome_dir}"/mouse

if [ -a "${genome_dir}"/mouse/"${name}" ] || [ -a "${genome_dir}"/mouse/Mus_musculus.GRCm38.dna.primary_assembly.fa ]
then
  echo "Genomes already downloaded"
else
  curl "${genome}" > "${genome_dir}"/mouse/"${name}"
fi

#INDEX MOUSE GENOME -

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

output=$( echo "${name}" | cut -d'.' -f1 )

#first gunzip reference genome
if [ -a "${genome_dir}"/mouse/Mus_musculus.GRCm38.dna.primary_assembly.fa ]
then
  echo "Genome already gunzipped"
else
  gunzip "${genome_dir}"/mouse/"${name}"
fi

#index using hisat2-build from gunzipped file, caffeinate run to prevent mac going to sleep overnight
cd "${DIR}"

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

# gunzip fq.gz files run hisat2 programme to map reads, output hisat2 mapping stats into a text files
[[ -e "${cutadapt}"/*.fa ]] || gunzip "${cutadapt}"/*.gz

if [ -a "${genome_dir}"/mouse/mouse_splice_sites.txt ]; then
  echo "Splice sites already generated to text file"
else
  hisat2_extract_splice_sites.py "${genome_dir}"/mouse/Mus_musculus.GRCm38.99.gtf > "${genome_dir}"/mouse/mouse_splice_sites.txt
fi

#hisat2 mapping - mid-cells
source "${conda_source}"
conda activate "${conda_env}"

for sample in 1 4 6 ; do

  hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome_dir}"/mouse/mouse_splice_sites.txt \
  "${cutadapt}"/"${sample}"Bound-mid_trim.fq \
  --summary-file "${analysis}"/mapping/"${sample}"Bound-mid_hisat2_mapping.txt \
  | samtools view -bS - > "${analysis}"/mapping/"${sample}"Bound-mid.hisat.bam

done

hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome_dir}"/mouse/mouse_splice_sites.txt \
"${cutadapt}"/4Input-mid_trim.fq \
--summary-file "${analysis}"/mapping/4Input-mid_hisat2_mapping.txt \
| samtools view -bS - > "${analysis}"/mapping/4Input-mid.hisat.bam

#hisat2 mapping - neg-cells
for sample in 2 3 5 7 8 ; do

  hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome_dir}"/mouse/mouse_splice_sites.txt \
  "${cutadapt}"/"${sample}"Bound-neg_trim.fq \
  --summary-file "${analysis}"/mapping/"${sample}"Bound-neg_hisat2_mapping.txt \
  | samtools view -bS - > "${analysis}"/mapping/"${sample}"Bound-neg.hisat.bam

done

hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome_dir}"/mouse/mouse_splice_sites.txt \
"${cutadapt}"/5Input-neg_trim.fq \
--summary-file "${analysis}"/mapping/5Input-neg_hisat2_mapping.txt \
| samtools view -bS - > "${analysis}"/mapping/5Input-neg.hisat.bam

mkdir -p "${analysis}"/mapping/txt
mv "${analysis}"/mapping/*.txt "${analysis}"/mapping/txt

#RUN MULTIQC TO GET SUMMARY STATS ON mapping

mkdir -p "${QC}"/hisat2_mapping
multiqc -f "${analysis}"/mapping

mv ./multiqc_data/* "${QC}"/hisat2_mapping/
rm -r ./multiqc_data
mv ./multiqc_report.html "${QC}"/hisat2_mapping/
