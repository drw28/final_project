#INDEX MOUSE GENOME

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
  caffeinate hisat2-build -f "${genome_dir}"/mouse/"${name/.gz}" "${output}"
fi

#move output files into genome folder
mv "${DIR}"/*.ebwt "${genome_dir}"/mouse

#MAP READS

#locations and basenaming of genome
name=$(basename "${genome}" | cut -d'.' -f1)

mkdir "${DIR}"/analysis/rna_seq/mapping

#activate conda environment
source "${conda_source}"
conda activate "${conda_env}"

#make mapping directory, gunzip fq.gz files run hisat2 programme to map reads, output hisat2 mapping stats into a text files
gunzip "${cutadapt}"/*.gz
hisat2_extract_splice_sites.py Mus_musculus.GRCm38.99.gtf > mouse_splice_sites.txt

for sample in 1 2 3 4 5 6 7 8 ; do

  hisat2 --phred64 -x "${genome_dir}"/mouse/Mus_musculus --known-splicesite-infile "${genome}"/mouse/mouse_splice_sites.txt \
  -p 2 -1 "${cutadapt}"/"${sample}"_A* -2 "${cutadapt}"/"${sample}"_B* \
  --summary-file "${DIR}"/analysis/rna_seq/mapping/hisat2_mapping.txt \
  | samtools view -bS - > "${DIR}"/analysis/rna_seq/mapping/"${sample}".hisat.bam

done

#RUN MULTIQC TO GET SUMMARY STATS ON mapping

mkdir -p "${QC}"/hisat2_mapping

multiqc -f "${analysis}"/mapping

mv ./multiqc_data/* "${QC}"/hisat2_mapping
rm -r ./multiqc_data
mv ./multiqc_report.html "${QC}"/hisat2_mapping
