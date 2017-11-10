//Technique 1
//Count array act as a multiple bucket set
//frequent-items-using-CUDA

#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
#include<stdio.h>
#include <stdlib.h>
#include<time.h>
#include<fstream>
using namespace std;

__global__ void addKernel(int *a,int *count_d,int *nOfItemSet_d)
{
  int i=blockIdx.x*blockDim.x+threadIdx.x;
  int val=a[blockIdx.x*blockDim.x+threadIdx.x];
  atomicAdd(&count_d[1000*(int(i/5000))+val],1);		//right
  //count_d[threadIdx.x]=a[threadIdx.x];
  if(i<1000){
	for(int j=1;j< *nOfItemSet_d;i++){
		count_d[i]=count_d[i]+count_d[j*1000+i];
	}
  }
}

int main(){
int n;
cout<<"enter number of transaction";
cin>>n;
ifstream in("out.txt");
int *a_d,*a_h,*count_d,*count_h,*nOfItemSet_d,*nOfItemSet_h;
int size=n*sizeof(int);
int size1=1000*sizeof(int);

a_h=(int*)malloc(n*sizeof(int));
count_h=(int*)malloc(1000*sizeof(int));
nOfItemSet_h=(int*)malloc(sizeof(int));

for(int i=0;i<n;i++)
{
	in>>a_h[i];
}

for(int i=0;i<1000;i++)
	count_h[i]=0;
*nOfItemSet_h=((n-1)/5000)+1;

cudaMalloc((void**)&a_d,size);
cudaMalloc((void**)&count_d,size1);
cudaMalloc((void**)&nOfItemSet_d,sizeof(int));
cudaMemcpy(a_d,a_h,size,cudaMemcpyHostToDevice);
cudaMemcpy(count_d,count_h,size1,cudaMemcpyHostToDevice);
cudaMemcpy(nOfItemSet_d,nOfItemSet_h,sizeof(int),cudaMemcpyHostToDevice);

addKernel<<<((n-1)/256)+1,256>>>(a_d,count_d,nOfItemSet_d);

cudaMemcpy(count_h,count_d,size1,cudaMemcpyDeviceToHost);
cudaFree(a_d);
cudaFree(count_d);
for(int i=0;i<1000;i++)
	cout<<i<<" "<<count_h[i]<<endl;
//cout<<"time taken: "<<(double) (end-start) / CLOCKS_PER_SEC * 1000.0;
return 0;

}

