# inf_520_labeled_graph_compression

Prerequisites
==============
1. Install SDSL using the step 1 found at: https://compact-leapfrog.tk 

2. Download the following input file: http://compact-leapfrog.tk/files/wikidata-filtered-enumerated.dat

1rst experiment
===============
1. Compile adapted_front_coding_appoach:
    cd adapted_front_coding_approach/
    ./build_release.sh
2. Run the experiment:
    ./run_graph_compression_test_front_coding.sh <path_to_triple_file>

2nd experiment
===============
1. Compile BWT_approach:
    cd BWT_approach/
    make
    ./build_release.sh
