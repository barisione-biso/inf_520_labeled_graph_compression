#!/usr/bin/env sh
#example of execution
#./run_graph_compression_test_mtf_shuff.sh full /home/fabrizio/dcc_uchile/Ring/Ring/ /home/fabrizio/dcc_uchile/Ring/dat/

die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 3 ] || die "3 arguments required, $# provided. example: ./run_graph_compression_test_mtf_shuff.sh full|part1|part2 ring_project_dir mtf_files_dir"

do_shuff () {
    mtf_file=$1
    echo "--- MTF for $mtf_file"
    echo "--- Shuff - Executing 2 steps process encoding..."
    #Two pass shuff process.
    ./shuff -e1 ${mtf_file}_shuff_freqs $mtf_files_dir/$mtf_file -v1
    ./shuff -e2 ${mtf_file}_shuff_freqs $mtf_files_dir/$mtf_file -v1 > ${mtf_file}_shuff_encoded
    #One pass shuff process.
    #./shuff -e -b 262144 ../../../Ring/dat/${mtf_file} -v1 
    echo "--- Shuff - decoding file"
    ./shuff -d ${mtf_file}_shuff_encoded > "${mtf_files_dir}${mtf_file}_shuff_decoded"
    
    echo "--- comparing original and decoded files."

    if cmp -s "${mtf_files_dir}${mtf_file}" "${mtf_files_dir}${mtf_file}_shuff_decoded"; then
        printf '    The file "%s" is the same as "%s"\n' "${mtf_files_dir}${mtf_file}" "${mtf_files_dir}${mtf_file}_shuff_decoded"
    else
        printf '    The file "%s" is different from "%s"\n' "${mtf_files_dir}${mtf_file}" "${mtf_files_dir}${mtf_file}_shuff_decoded"
    fi

    ls -lh ${mtf_file}_shuff_encoded
    ls -lh "${mtf_files_dir}${mtf_file}"
}
shuff_working_dir="$(pwd)"
echo "working directory : $shuff_working_dir"
mode=$1
ring_dir="$2"
mtf_files_dir="$3"
if [[ $mode == full ]] || [[ $mode == part1 ]]; then
    echo "========================================================================"
    echo "Step 1: Ring index + MTF BWT_{s,p,o} encoding"
    echo "========================================================================"
    cd $ring_dir
    echo "--- Building ring - release"
    ./build_release.sh
    echo "--- Creating index"
    ./text_compression_test_create.sh
    echo "--- Saving mtf encoded BWT_{s,p,o} "
    ./text_compression_test_load.sh
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
    rm -f shuff_freqs ${mtf_file[0]}_shuff_encoded $"${mtf_files_dir}${mtf_file[0]}"
    rm -f shuff_freqs ${mtf_file[1]}_shuff_encoded $"${mtf_files_dir}${mtf_file[1]}"
    rm -f shuff_freqs ${mtf_file[2]}_shuff_encoded $"${mtf_files_dir}${mtf_file[2]}"
fi