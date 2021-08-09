#include <iostream>
#include "triple_bwt.hpp"
#include <fstream>
#include <sdsl/construct.hpp>

using namespace std;

using namespace std::chrono;
using timer = std::chrono::high_resolution_clock;

void create_index(string filename)
{
    vector<spo_triple> D;
    std::ifstream ifs(filename);
    uint64_t s, p , o;
    //cout << "Step 1: loading triples"<<endl;
    int i=0;
    do {
        ifs >> s >> p >> o;
        D.push_back(spo_triple(s, p, o));
        i++;
        //if(i>=90000)
          //  break;
    } while (!ifs.eof());
    ifs.close();
    D.shrink_to_fit();
    cout << "--Loaded " << D.size() << " triples" << endl;
    //cout << "Step 2: creating the Ring with 3 BTWs"<<endl;
    triple_bwt ring;
    ring.index(D);
    ring.save(filename);
}

string get_directory(string filename)
{
    string directory;
    const size_t last_slash_idx = filename.rfind('/');
    if (std::string::npos != last_slash_idx)
    {
        directory = filename.substr(0, last_slash_idx);
    }
    //std::cout << "directory : " << directory << std::endl;
    return directory;
}
void load_index(string filename)
{
    triple_bwt ring;
    ring.load(filename);
    string directory = get_directory(filename);
    ring.apply_MTF_v(directory);
}
int main(int argc, char **argv)
{

    memory_monitor::start();
    auto start = timer::now();
    if (string(argv[2])=="create"){
        create_index(string(argv[1]));
    }else{
        load_index(string(argv[1]));
        //cout << "Binary MTF files correctness can be check with ./test_loading_uint32_binary_file program"<<endl;
    }
    auto stop = timer::now();
    std::cout << "--Done in "  << duration_cast<seconds>(stop-start).count() << " seconds." << endl;
    memory_monitor::stop();
    std::cout << memory_monitor::peak() << " bytes." << endl;

    return 0;
}

