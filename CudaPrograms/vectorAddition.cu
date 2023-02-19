%%cu
#include<iostream>
#include<cuda.h>
using namespace std;

//function declaration
__global__ void vectorAdd(float*,float*,float*,int);


//function(kernel) Defination
__global__ void vectorAdd(float *A,float *B,float *C,int n){

    int id= threadIdx.x +blockDim.x*blockIdx.x;    // Id of particular thread:

    if(id<n)
        C[id]=A[id]+B[id];   
}

 //host program
 int main(){
   
    float h_A[]={1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8};
    float h_B[]={1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8};

    int n=sizeof(h_A)/sizeof(float);        // number of element in array
    float h_C[n];
    int size=sizeof(h_A);                   //size of array

    //gpu variables
    float *d_A,*d_B,*d_C;

    // memory allocation in gpu device
    cudaMalloc((void**)&d_A,size);
    cudaMalloc((void**)&d_B,size);
    cudaMalloc((void**)&d_C,size);

    
    //host to device data memory transfer
    cudaMemcpy(d_A ,h_A ,size , cudaMemcpyHostToDevice);
    cudaMemcpy(d_B ,h_B ,size , cudaMemcpyHostToDevice);


    //number of threads and block launch:
    int threadPerBlock = 256;
    int blockPerGrid = (n+threadPerBlock-1)/threadPerBlock;

    //kernel launch:
    vectorAdd<<<blockPerGrid,threadPerBlock>>>(d_A,d_B,d_C,n); 

    
    //device to host memory transfer:
    cudaMemcpy(h_C ,d_C ,size , cudaMemcpyDeviceToHost);


    //deallocate the memory space in gpu device:
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    
    //traversal of output array:
    cout<<"output: ";
    for(int i=0;i<n;i++){
    cout<<h_C[i]<<" ";
    }
    return 0;
}