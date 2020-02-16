DIR=/users/dougwicks/documents/biochem/final_year/project

genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"

genome_dir="${DIR}"/analysis/genome_dir
mkdir "${genome_dir}"
name=$(basename "${genome}")
curl "${genome}" > "${genome_dir}"/"${name}"
