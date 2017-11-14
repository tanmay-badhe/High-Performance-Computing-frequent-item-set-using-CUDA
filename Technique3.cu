#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
#include<stdio.h>
#include <stdlib.h>
#include<time.h>
#include<fstream>
using namespace std;

__global__ void addKernel(int *a,int *count_d)
{
  __shared__ int c[1000];
  int i=threadIdx.x;
  int val=a[blockIdx.x*blockDim.x+threadIdx.x];
  if(i<250){
     c[i]=0;
     c[i+250]=0;
     c[i+500]=0;
     c[i+750]=0;
 }
  __syncthreads();
  atomicAdd(&c[val],1);
  __syncthreads();
  if(i<250){
	atomicAdd(&count_d[i],c[i]);
	atomicAdd(&count_d[i+250],c[i+250]);
	atomicAdd(&count_d[i+500],c[i+500]);
	atomicAdd(&count_d[i+750],c[i+750]);
  }
  
}

int main(){
int n;
cout<<"enter number of transaction";
cin>>n;
ifstream in("out.txt");
int *a_d,*a_h,*count_d,*count_h;
int size=n*sizeof(int);
int size1=1000*sizeof(int);
a_h=(int*)malloc(n*sizeof(int));
count_h=(int*)malloc(1000*sizeof(int));
for(int i=0;i<n;i++)
{
	in>>a_h[i];
}
for(int i=0;i<1000;i++)
	count_h[i]=0;
cudaMalloc((void**)&a_d,size);
cudaMalloc((void**)&count_d,size1);
cudaMemcpy(a_d,a_h,size,cudaMemcpyHostToDevice);
cudaMemcpy(count_d,count_h,size1,cudaMemcpyHostToDevice);
addKernel<<<((n-1)/256)+1,256>>>(a_d,count_d);
cudaMemcpy(count_h,count_d,size1,cudaMemcpyDeviceToHost);
cudaFree(a_d);
cudaFree(count_d);
for(int i=0;i<1000;i++)
	cout<<i<<" "<<count_h[i]<<endl;
return 0;

}

