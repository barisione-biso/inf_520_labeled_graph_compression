#!/usr/bin/env sh

die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 2 ] || die "2 arguments required, $# provided. example: ./run_graph_compression_test_mtf_shuff.sh full|part1|part2 input_file"

do_shuff () {
    mtf_file=$1
    echo "Applying Huffman to $mtf_file"
    echo "============================="
    #echo "--- Shuff - Executing 2 steps process encoding..."
    #Two pass shuff process.
    ./shuff -e1 ${mtf_file}_shuff_freqs $input_path/$mtf_file #for more details add -v1
    ./shuff -e2 ${mtf_file}_shuff_freqs $input_path/$mtf_file  > ${mtf_file}_shuff_encoded #for more details add -v1
    echo "--- Done"
    #One pass shuff process.
    #./shuff -e -b 262144 ../../../Ring/dat/${mtf_file} -v1 
    echo "--- Shuff - decoding file"
    ./shuff -d ${mtf_file}_shuff_encoded > "${input_path}/${mtf_file}_shuff_decoded"
    
    echo "--- comparing original and decoded files."

    if cmp -s "${input_path}/${mtf_file}" "${input_path}/${mtf_file}_shuff_decoded"; then
        printf '    The file "%s" is the same as "%s"\n' "${input_path}/${mtf_file}" "${input_path}/${mtf_file}_shuff_decoded"
    else
        printf '    The file "%s" is different from "%s"\n' "${input_path}/${mtf_file}" "${input_path}/${mtf_file}_shuff_decoded"
    fi

    ls -lh ${mtf_file}_shuff_encoded
    ls -lh ${mtf_file}_shuff_freqs
    ls -lh "${input_path}/${mtf_file}"
    ls -lh "${input_path}/${mtf_file}_shuff_decoded"

    rm -f ${mtf_file}_shuff_encoded
    rm -f ${mtf_file}_shuff_freqs
    rm -f "${input_path}/${mtf_file}"
    rm -f "${input_path}/${mtf_file}_shuff_decoded"
}
shuff_working_dir="$(pwd)"
echo "working directory : $shuff_working_dir"
mode=$1
input_file=$(basename $2)
input_path=$(dirname $2)
echo "input_file: "${input_path}"/"${input_file}""
echo "--- Building code"
./build_release.sh
if [[ $mode == full ]] || [[ $mode == part1 ]]; then
    echo "========================================================================"
    echo "Step 1: Ring index + MTF BWT_{s,p,o} encoding"
    echo "========================================================================"
    echo "--- Creating index"
    #./text_compression_test_create.sh
    ./text_compression_test "${input_path}"/"${input_file}" create
    ls -lh "${input_path}"/"${input_file}.bwts.int_vector"
    ls -lh "${input_path}"/"${input_file}.bwts.compressed_int_vector"
    ls -lh "${input_path}"/"${input_file}.bwtp.int_vector"
    ls -lh "${input_path}"/"${input_file}.bwtp.compressed_int_vector"
    ls -lh "${input_path}"/"${input_file}.bwto.int_vector"
    ls -lh "${input_path}"/"${input_file}.bwto.compressed_int_vector"
    echo "deleting tmp files..."
    rm -f "${input_path}"/"${input_file}.bwts.int_vector"
    rm -f "${input_path}"/"${input_file}.bwts.compressed_int_vector"
    rm -f "${input_path}"/"${input_file}.bwtp.int_vector"
    rm -f "${input_path}"/"${input_file}.bwtp.compressed_int_vector"
    rm -f "${input_path}"/"${input_file}.bwto.int_vector"
    rm -f "${input_path}"/"${input_file}.bwto.compressed_int_vector"
    echo "--- Saving mtf encoded BWT_{s,p,o} "
    #./text_compression_test_load.sh
    ./text_compression_test "${input_path}"/"${input_file}" load

    ls -lh "${input_path}"/"${input_file}.alphabet_s"
    ls -lh "${input_path}"/"${input_file}.alphabet_p"
    ls -lh "${input_path}"/"${input_file}.alphabet_o"

    rm -f "${input_path}"/"${input_file}.alphabet_s"
    rm -f "${input_path}"/"${input_file}.alphabet_p"
    rm -f "${input_path}"/"${input_file}.alphabet_o"
fi
mtf_file=("mtf_s" "mtf_p" "mtf_o")
if [[ $mode == full ]] || [[ $mode == part2 ]]; then
    cd "${shuff_working_dir}"
    echo "========================================================================"
    echo "Step 2: Huffman"
    echo "========================================================================"
    echo "--- Important: please read shuff.pdf to understand the encoding."

    #echo ${mtf_file[0]}
    do_shuff ${mtf_file[0]}
    do_shuff ${mtf_file[1]}
    do_shuff ${mtf_file[2]}
fi

#if [[ $mode == full ]]; then
#    ls -lh ${mtf_file[0]}_shuff_freqs ${mtf_file[0]}_shuff_encoded "${input_path}/${mtf_file[0]}"
#    ls -lh ${mtf_file[1]}_shuff_freqs ${mtf_file[1]}_shuff_encoded "${input_path}/${mtf_file[1]}"
#    ls -lh ${mtf_file[2]}_shuff_freqs ${mtf_file[2]}_shuff_encoded "${input_path}/${mtf_file[2]}"
#    echo "deleting tmp & decoded file(s) "
#    rm -f ${mtf_file[0]}_shuff_freqs ${mtf_file[0]}_shuff_encoded "${input_path}/${mtf_file[0]}"
#    rm -f ${mtf_file[1]}_shuff_freqs ${mtf_file[1]}_shuff_encoded "${input_path}/${mtf_file[1]}"
#    rm -f ${mtf_file[2]}_shuff_freqs ${mtf_file[2]}_shuff_encoded "${input_path}/${mtf_file[2]}"
#fi