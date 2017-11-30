//Tanmay Badhe & Amit Nene
//outputs- each item count and max count item with its max count

#include<iostream>
#include<string>
#include<fstream>
using namespace std;


class HPC
{
public: 	
	long i;
	long item_count[1000],item;
public:
	int readfile();
	int max_item();
	int print();
	int freq_max_item();
public:
HPC()
{
for(int i=0;i<1000;i++)
{
item_count[i]=0;
}
}
};
int HPC::readfile()
{

ifstream in("inputfile.txt");
	
for(i=0;in>>item;i++){		
		item_count[item]++;
	}

return 0;
}


int HPC::max_item()
{
int max=0;
for(i=0;i<1000;i++){
		
		if(item_count[i]>item_count[max])
			max=i;
	}

return max;
}

int HPC::print()
{
for(i=0;i<1000;i++)
{
cout<<i<<" has occured "<<item_count[i]<<" times\n";
}
return 0;
}


int HPC::freq_max_item()
{
int max=max_item();
return item_count[max];
}

int main(){
	HPC h;
	
	clock_t start = clock();
	h.readfile();
	clock_t end = clock();
	int max_1=h.max_item();
	h.print();
	int freq_max_item=h.freq_max_item();
	cout<<"max occuring item is "<<max_1<<" with count "<<freq_max_item<<endl;
 	cout<<"time taken: "<<(double) (end-start) / CLOCKS_PER_SEC * 1000.0;
return 0;
}


