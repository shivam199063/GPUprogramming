%%cu
//Mul two 2D matrix 
// here we launch one single thread in each block


#include<stdio.h>
#include<cuda.h>
#define row1 2
#define row2 4
#define col1 4
#define col2 2

__constant__ float x[row1][col1];

__global__ void vectorMul(float *y, float *z){
    __shared__ int p[col1];
    int row = blockIdx.y;
    int col = blockIdx.x;
    int k = threadIdx.x;
    z[row*col2+col]=0;
    p[k]= x[row][k]*y[k*col2+col];
    
    __syncthreads();
    for(int i=0;i<col1;i++){

        z[row*col2+col]=z[row*col2+col]+p[i];
    }


}

int main(int *argc,char **argv[]){
    
    float c[row1][col1]={{1,2,3,4},{5,6,7,8}};
    float y[row2][col2]={{1,2},{3,4},{5,6},{7,8}};
    float z[row1][col2];
    
    //variables for gpu
    
    float *d_y;
    float *d_z;

    //now we allocate space in gpu memory
    int array_size=row1*col1*sizeof(float);
    int array_size_z=row1*col2*sizeof(float);

    
    cudaMalloc( (void**)&d_y,array_size);
    cudaMalloc( (void**)&d_z,array_size_z);

    //now we copy these vector(array) in gpu memory
    cudaMemcpyToSymbol( x, c, array_size);
    cudaMemcpy( d_y, y , array_size , cudaMemcpyHostToDevice);
    
    dim3 blocks(row1,col2,1);
    // now we launch kernel
    vectorMul<<<blocks,col1>>>(d_y,d_z);

    // copy array from gpu to cpu memory
    cudaMemcpy( z , d_z , array_size_z , cudaMemcpyDeviceToHost);

  
    cudaFree( d_y);
    cudaFree( d_z);


    // print the values of output array
      printf("values of array z:\n");
    for(int i=0;i<row1;i++){
        for(int j=0;j<col2;j++){
        printf(" %f",z[i][j]);
        }
        printf("\n");
    }
return 0;
}