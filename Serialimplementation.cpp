//Tanmay Badhe
//outputs- each item count and max count item with its max count

#include<iostream>
#include<string>
#include<fstream>
using namespace std;

int main(){
	ifstream in("inputfile.txt");
	long i;
	long item_count[1000],item,max=0;
	for(i=0;i<1000;i++)
		item_count[i]=0;
	clock_t start = clock();
	for(i=0;in>>item;i++){		
		item_count[item]++;
	}
	clock_t end = clock();
	for(i=0;i<1000;i++){
		cout<<i<<" "<<item_count[i]<<endl;
		if(item_count[i]>item_count[max])
			max=i;
	}
	cout<<"max occuring item is "<<max<<" with count "<<item_count[max]<<endl;
 	cout<<"time taken: "<<(double) (end-start) / CLOCKS_PER_SEC * 1000.0;
return 0;
}
