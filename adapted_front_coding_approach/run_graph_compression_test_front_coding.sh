#!/usr/bin/env sh
#example: 
#./run_graph_compression_test_front_coding.sh ../../../Ring/dat/wikidata-filtered-enumerated.dat
#or alternatively:
#time ./run_graph_compression_test_front_coding.sh ../../../Ring/dat/wikidata-filtered-enumerated.dat
./build_release.sh
file="test.dat"
if [ -n "$1" ];
then
    file=$1
fi
echo "working file : $file"
echo "part 1 : encoding"
./front_coding_encode $file

#OPTIONAL:
#echo "part 2: decoding"
#./front_coding_decode $file

#ls -lh $file
#ls -lh "$file.elias_delta"
rm -f "$file.elias_delta"
#ls -lh "$file.elias_gamma"
rm -f "$file.elias_gamma"
#ls -lh "$file.fibonacci"
rm -f "$file.fibonacci"