#include <iostream>
#include "/home/fabrizio/dcc_uchile/Ring/Ring/triple_bwt.hpp"
#include <fstream>

using timer = std::chrono::high_resolution_clock;

vector<spo_triple> decode_vector(vlc_vector<sdsl::coder::elias_delta> ev){
    uint64_t i, s = 0, p = 0, o = 0;
    std::cout <<  " coder::elias_delta " << endl;
    vector<spo_triple> v;
    vlc_vector<sdsl::coder::elias_delta>::iterator it, begin = ev.begin(), end = ev.end();
    bool clean_s = true, clean_p = true, clean_o = true;
    for (i = 0, it = begin; it != end; it++, i++){
        auto current_number = *it;
        if(current_number != 0){
            if(clean_s){
                clean_s = false;
                s = s + current_number -1;
            }else{
                if(clean_p){
                    clean_p = false;
                    p = p + current_number -1;
                }else{
                    if(clean_o){
                        clean_o = false;
                        o = o + current_number -1;
                    }
                }
            }

            if(!clean_s && !clean_p && !clean_o){
                v.push_back(spo_triple(s, p, o));
                clean_o = true;
            }
        }else{
            //reading a zero.
            clean_o = true;
            o = 0;
            if(!clean_p){
                //one zero read.
                clean_p = true;
            }else{
                clean_s = true;
                p = 0;
            }
        }
    }
    return v;
}

vector<spo_triple> decode_vector(vlc_vector<sdsl::coder::elias_gamma> ev){
    uint64_t i, s = 0, p = 0, o = 0;
    std::cout <<  " coder::elias_gamma " << endl;
    vector<spo_triple> v;
    vlc_vector<sdsl::coder::elias_gamma>::iterator it, begin = ev.begin(), end = ev.end();
    bool clean_s = true, clean_p = true, clean_o = true;
    for (i = 0, it = begin; it != end; it++, i++){
        auto current_number = *it;
        if(current_number != 0){
            if(clean_s){
                clean_s = false;
                s = s + current_number -1;
            }else{
                if(clean_p){
                    clean_p = false;
                    p = p + current_number -1;
                }else{
                    if(clean_o){
                        clean_o = false;
                        o = o + current_number -1;
                    }
                }
            }

            if(!clean_s && !clean_p && !clean_o){
                v.push_back(spo_triple(s, p, o));
                clean_o = true;
            }
        }else{
            //reading a zero.
            clean_o = true;
            o = 0;
            if(!clean_p){
                //one zero read.
                clean_p = true;
            }else{
                clean_s = true;
                p = 0;
            }
        }
    }
    return v;
}

vector<spo_triple> decode_vector(vlc_vector<sdsl::coder::fibonacci> ev){
uint64_t i, s = 0, p = 0, o = 0;
    std::cout <<  " coder::fibonacci " << endl;
    vector<spo_triple> v;
    vlc_vector<sdsl::coder::fibonacci>::iterator it, begin = ev.begin(), end = ev.end();
    bool clean_s = true, clean_p = true, clean_o = true;
    for (i = 0, it = begin; it != end; it++, i++){
        auto current_number = *it;
        if(current_number != 0){
            if(clean_s){
                clean_s = false;
                s = s + current_number -1;
            }else{
                if(clean_p){
                    clean_p = false;
                    p = p + current_number -1;
                }else{
                    if(clean_o){
                        clean_o = false;
                        o = o + current_number -1;
                    }
                }
            }

            if(!clean_s && !clean_p && !clean_o){
                v.push_back(spo_triple(s, p, o));
                clean_o = true;
            }
        }else{
            //reading a zero.
            clean_o = true;
            o = 0;
            if(!clean_p){
                //one zero read.
                clean_p = true;
            }else{
                clean_s = true;
                p = 0;
            }
        }
    }
    return v;
}

int main(int argc, char **argv)
{
    uint64_t i;
    vector<spo_triple> D;
    string filename= argv[1];
    
    memory_monitor::start();
    auto start = timer::now();
    {
        sdsl::vlc_vector<sdsl::coder::elias_delta> ev_d;
        sdsl::load_from_file(ev_d, filename+".elias_delta");
        //std::cout << "ev_d: " << ev_d << endl;
        vector<spo_triple> v = decode_vector(ev_d);
        std::cout << "decoded delta size : " << v.size() << endl;
        /*for (auto i = 0; i < v.size(); i++){
            spo_triple t = v[i];
            std::cout << std::get<0>(t) << " " << std::get<1>(t) << " " << std::get<2>(t) << endl;
        }*/
        
    }
    {
        sdsl::vlc_vector<sdsl::coder::elias_gamma> ev_g;
        sdsl::load_from_file(ev_g, filename+".elias_gamma");
        //std::cout << "ev_g: " << ev_g << endl;
        vector<spo_triple> v = decode_vector(ev_g);
        std::cout << "decoded gamma size : " << v.size() << endl;
        /*for (auto i = 0; i < v.size(); i++){
            spo_triple t = v[i];
            std::cout << std::get<0>(t) << " " << std::get<1>(t) << " " << std::get<2>(t) << endl;
        }*/
    }
    {
        sdsl::vlc_vector<sdsl::coder::fibonacci> ev_f;
        sdsl::load_from_file(ev_f, filename+".fibonacci");
        //std::cout << "ev_f: " << ev_f << endl;
        vector<spo_triple> v = decode_vector(ev_f);
        std::cout << "decoded fibonacci size : " << v.size() << endl;
        /*for (auto i = 0; i < v.size(); i++){
            spo_triple t = v[i];
            std::cout << std::get<0>(t) << " " << std::get<1>(t) << " " << std::get<2>(t) << endl;
        }*/
    }
    auto stop = timer::now();
    memory_monitor::stop();
    
    cout << std::chrono::duration_cast<std::chrono::seconds>(stop-start).count() << " seconds." << endl;
    cout << memory_monitor::peak() << " bytes." << endl;
    return 0;
}

