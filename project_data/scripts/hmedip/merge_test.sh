#key directory variables below

DIR=/Volumes/Recovered_Mac/project
analysis="${DIR}"/project_data/analysis/hmeDIP-seq
raw_data="${analysis}"/raw-data

#Merge "_p2" file names using 'for' loop

if [ -a "${raw_data}"/1Bound_p2.927.s_1.r_1.fq.gz ] ; then
  cat "${raw_data}"/1Bound.927.s_1.r_1.fq.gz "${raw_data}"/1Bound_p2.927.s_1.r_1.fq.gz \
  > "${raw_data}"/1Bound.927.s_1m.r_1.fq.gz
  rm 1Bound.927.s_1.r_1.fq.gz 1Bound_p2.927.s_1.r_1.fq.gz
  rename 's/s_1m/s_1/' "${raw_data}"/1Bound.927.s_1m.r_1.fq.gz
else
  echo "1Bound already merged"
fi

if [ -a  "${raw_data}"/6Bound_p2.927.s_2.r_1.fq.gz ] ; then
  cat "${raw_data}"/6Bound.927.s_2.r_1.fq.gz "${raw_data}"/6Bound_p2.927.s_2.r_1.fq.gz \
  > "${raw_data}"/6Bound.927.s_2m.r_1.fq.gz
  rm 6Bound.927.s_2.r_1.fq.gz 6Bound_p2.927.s_2.r_1.fq.gz
  rename 's/s_2m/s_2/' "${raw_data}"/6Bound.927.s_2m.r_1.fq.gz
else
  echo "6Bound already merged"
fi
