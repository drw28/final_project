DIR=/Volumes/Recovered_Mac/project

#insert location of genome for download within quotation marks
genome="ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz"

#create folder for genome to be downloaded into
genome_dir="${DIR}"/genome_dir/mouse
mkdir -p "${genome_dir}"

#use basename of reference as name of new file in directory, and download into new genome folder
name=$(basename "${genome}")
curl "${genome}" > "${genome_dir}"/"${name}"
