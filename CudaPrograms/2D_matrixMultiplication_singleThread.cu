%%cu
//Mul two 2D matrix 
// here we launch one single thread in each block


#include<stdio.h>
#include<cuda.h>
#define row1 2
#define row2 4
#define col1 4
#define col2 2

__global__ void vectorMul(float *a,float *b, float *c){
    int row= blockIdx.y*blockDim.y+threadIdx.y;
    int col= blockIdx.x*blockDim.x+threadIdx.x;
    int width_a= col1;
    int width_b= col2;
    int width_c= col2;      
    float sum=0;
    for(int i=0;i<col1;i++){
    sum = sum + a[row*width_a+i]*b[i*width_b+col];
    }
    c[row*width_c+col] = sum;
}

int main(int *argc,char **argv[]){
    
    float x[row1][col1]={{1,2,3,4},{5,6,7,8}};
    float y[row2][col2]={{1,2},{3,4},{5,6},{7,8}};
    float z[row1][col2];
    
    //variables for gpu
    float *d_x;
    float *d_y;
    float *d_z;

    //now we allocate space in gpu memory
    int array_size=row1*col1*sizeof(float);
    int array_size_z=row1*col2*sizeof(float);

    cudaMalloc( (void**)&d_x,array_size);
    cudaMalloc( (void**)&d_y,array_size);
    cudaMalloc( (void**)&d_z,array_size_z);

    //now we copy these vector(array) in gpu memory
    cudaMemcpy( d_x, x , array_size , cudaMemcpyHostToDevice);
    cudaMemcpy( d_y, y , array_size , cudaMemcpyHostToDevice);
    
    dim3 blocks(row1,col2,1);
    // now we launch kernel
    vectorMul<<<blocks,1>>>(d_x,d_y,d_z);

    // copy array from gpu to cpu memory
    cudaMemcpy( z , d_z , array_size_z , cudaMemcpyDeviceToHost);

    cudaFree( d_x);
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