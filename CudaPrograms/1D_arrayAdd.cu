%%cu
//add two 1D matrix 
// here we launch one single block which has user defined threads(let's threads =10)


#include<stdio.h>
#include<cuda.h>

__global__ void vectorAdd(float *x,float *y, float *z,int threads){
    int id= threadIdx.x;
    if(id<threads)
        z[id]=x[id]+y[id];
    else
        printf("You launch more than given threads: ");
}

int main(int *argc,char **argv[]){
    int threads=10;   //this value is user defined

    float x[threads]={1,2,3,4,5,6,7,8,9,10};
    float y[threads]={1,2,3,4,5,6,7,8,9,10};
    float z[threads];
    
    //variables for gpu
    float *d_x;
    float *d_y;
    float *d_z;

    //now we allocate space in gpu memory
    int array_size=threads*sizeof(float);

    cudaMalloc( (void**)&d_x,array_size);
    cudaMalloc( (void**)&d_y,array_size);
    cudaMalloc( (void**)&d_z,array_size);

    //now we copy these vector(array) in gpu memory
    cudaMemcpy( d_x, x , array_size , cudaMemcpyHostToDevice);
    cudaMemcpy( d_y, y , array_size , cudaMemcpyHostToDevice);

    // now we launch kernel
    vectorAdd<<<1,threads>>>(d_x,d_y,d_z,threads);

    // copy array from gpu to cpu memory
    cudaMemcpy( z , d_z , array_size , cudaMemcpyDeviceToHost);

    cudaFree( d_x);
    cudaFree( d_y);
    cudaFree( d_z);


    // print the values of output array
    printf("values of array z:\n");
    for(int j=0;j<threads;j++){
        printf(" %f",z[j]);
    }
return 0;
}