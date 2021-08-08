g++  -std=c++11 -I ~/include -L ~/lib build-index.cpp -o build-index -lsdsl -ldivsufsort -ldivsufsort64
g++  -std=c++11 -DNODEBUG -I ~/include -L ~/lib query-index.cc Triple.cpp Term.cpp -o query-index -lsdsl -ldivsufsort -ldivsufsort64
g++  -std=c++11 -I ~/include -L ~/lib text_compression_test.cpp -o text_compression_test -lsdsl -ldivsufsort -ldivsufsort64