%%cu
//add two 2D matrix 
// here we launch one single thread in each block
// here blocks are arrange in 2D form


#include<stdio.h>
#include<cuda.h>

__global__ void vectorAdd(float *a,float *b, float *c){
    int y= blockIdx.y;
    int x= blockIdx.x;
    int id= gridDim.x*y+x;
    c[id]=a[id]+b[id];
    
}

int main(int *argc,char **argv[]){
    int columns=3;
    int rows=4;  

    float x[rows][columns]={{1,2,9},{3,4,9},{1,2,9},{3,4,9}};
    float y[rows][columns]={{1,2,9},{3,4,9},{1,2,9},{3,4,9}};
    float z[rows][columns];
    
    //variables for gpu
    float *d_x;
    float *d_y;
    float *d_z;

    //now we allocate space in gpu memory
    int array_size=rows*columns*sizeof(float);

    cudaMalloc( (void**)&d_x,array_size);
    cudaMalloc( (void**)&d_y,array_size);
    cudaMalloc( (void**)&d_z,array_size);

    //now we copy these vector(array) in gpu memory
    cudaMemcpy( d_x, x , array_size , cudaMemcpyHostToDevice);
    cudaMemcpy( d_y, y , array_size , cudaMemcpyHostToDevice);

    // now we launch kernel
    dim3 blocks(rows,columns);
    vectorAdd<<<blocks,1>>>(d_x,d_y,d_z);

    // copy array from gpu to cpu memory
    cudaMemcpy( z , d_z , array_size , cudaMemcpyDeviceToHost);

    cudaFree( d_x);
    cudaFree( d_y);
    cudaFree( d_z);


    // print the values of output array
    printf("values of array z:\n");
    for(int i=0;i<rows;i++){
        for(int j=0;j<columns;j++){
        printf(" %f",z[i][j]);
        }
        printf("\n");
    }
return 0;
}