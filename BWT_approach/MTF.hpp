#ifndef _MTF_
#define _MTF_

#include <iostream>
#include <iterator>
#include <sstream>
#include <vector>

#include <sdsl/vectors.hpp>
#include <sdsl/bit_vectors.hpp>
using namespace std;

class MTF
{
public:
	MTF(uint64_t symbol_length)
	{
		symbols = symbol_length;
		//symbolTable = new char[symbols];
		//fillSymbolTable();
	}
	~MTF()
	{
		//delete symbolTable;
	}
	string encode( string &str )
	{
		fillSymbolTable();
		vector<int> output;
		for( string::iterator it = str.begin(); it != str.end(); it++ )
		{
			for( int i = 0; i < symbols; i++ )
			{
				if( *it == symbolTable[i] )
				{
					output.push_back( i );
					moveToFront( i );
					break;
				}
			}
		}
		string r;
		for( vector<int>::iterator it = output.begin(); it != output.end(); it++ )
		{
			ostringstream ss;
			ss << *it;
			r += ss.str() + " ";
		}
		return r;
	}

	string decode( string str )
	{
		fillSymbolTable();
		istringstream iss( str ); vector<int> output;
		copy( istream_iterator<int>( iss ), istream_iterator<int>(), back_inserter<vector<int> >( output ) );
		string r;
		for( vector<int>::iterator it = output.begin(); it != output.end(); it++ )
		{
			r.append( 1, symbolTable[*it] );
			moveToFront( *it );
		}
		return r;
	}

private:
	int symbols = 0;
	void moveToFront( int i )
	{
		char t = symbolTable[i];
		for( int z = i - 1; z >= 0; z-- )
		    symbolTable[z + 1] = symbolTable[z];

		symbolTable[0] = t;
	}
    void fillSymbolTable()
    {
        for( int x = 0; x < 26; x++ )
	    symbolTable[x] = x + 'a';
    }
 
    char symbolTable[26];
	/*
	void fillSymbolTable()
	{
		std::cout<< "MTF->fillSymbolTable()" <<endl;
		for( int x = 0; x < symbols; x++ ){
			symbolTable[x] = x+ 'a';
			cout << symbolTable[x];
		}
	}
	char *symbolTable;
	*/
};


#endif
