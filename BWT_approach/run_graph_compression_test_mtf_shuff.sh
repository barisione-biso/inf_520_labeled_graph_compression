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

    #ls -lh ${mtf_file}_shuff_encoded
    #ls -lh "${input_path}/${mtf_file}"
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
    echo "--- Saving mtf encoded BWT_{s,p,o} "
    #./text_compression_test_load.sh
    ./text_compression_test "${input_path}"/"${input_file}" load
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

if [[ $mode == full ]]; then
    echo "deleting tmp & decoded file(s) "
    rm -f shuff_freqs ${mtf_file[0]}_shuff_encoded "${input_path}/${mtf_file[0]}"
    rm -f shuff_freqs ${mtf_file[1]}_shuff_encoded "${input_path}/${mtf_file[1]}"
    rm -f shuff_freqs ${mtf_file[2]}_shuff_encoded "${input_path}/${mtf_file[2]}"
fi