#!/bin/bash

data_dir=fr_en_s
n1=2000
n2=2000
itr=20

for k in 10 20 30
do
  for num in 1 2 3 4 5 6 7 8 9 10
  do

    echo "experiment $num for k = $k"

    output_dir=$data_dir/output/k${k}_$num
    dictionary=$output_dir/spectral_map_k${k}.lex

    source=FR.afp.5M_100.2000
    target=EN.apw.5M_100.2000
    source_voc=${source}.words
    target_voc=${target}.words

    mkdir -p $output_dir

    matlab  -nojvm -r "path(path,'scripts'); extract_initial_correspondences('$data_dir/${source}.vectors', '$data_dir/${target}.vectors','$data_dir/${source}.words', '$data_dir/${target}.words', $k , '$dictionary'); exit" < /dev/null 

    perl scripts/lex2index.pl $dictionary $data_dir/$source_voc $data_dir/$target_voc
     
    #run greedy mapping
    matlab  -nojvm -r "path(path,'scripts'); greedy_mapping('$data_dir/${source}.vectors', '$data_dir/${target}.vectors','${dictionary}.ind', $n1, $n2, '$output_dir/${source}_${target}.map', $itr); exit" < /dev/null

    #replace indices with words
    perl scripts/index2lex.pl $output_dir/${source}_${target}.map $data_dir/$source_voc $data_dir/$target_voc


  done
done
