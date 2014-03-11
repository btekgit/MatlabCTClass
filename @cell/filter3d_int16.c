/* ==========================================================================
 * filter3d_int16.c
 * This function reads a Cell array, copies it to an array.
 * The main functions are cell2array and array2cell can be reused. 
 *
 * takes a (Mx1) cell matrix and returns a new cell (Mx1)
 * containing corresponding fields: for string input, it will be (Mx1) *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2006 The MathWorks, Inc.
 *==========================================================================*/
/* $Revision: 1.6.6.2 $ */

#include "mex.h"
#include "math.h"
#include <memory.h>
#include <string.h>

#define mxOutputType 	mxINT16_CLASS
#define DEBUGG  0 
typedef short InputType;
typedef short OperationType;
typedef short OutputType;


void cell2array(mxArray* pCell, OperationType** ppArray, int *nRows, int *nCols, int *nLength)
{
    mwSize     nCellElems;
    mxArray *tmp_cell;
    InputType* cell_element_ptr;
	OperationType* p_Out; 
	int  i = 0, j= 0, nR, nC, nL; 
    
    if(!mxIsCell(pCell))
        mexErrMsgTxt("Input to the function cell2array must be a cell");
	nCellElems = mxGetNumberOfElements(pCell);
    *nLength = nCellElems;
    
	if(DEBUGG)
		mexPrintf("total num of cells = %d \n", nCellElems);
	
    tmp_cell = (mxArray*) mxGetCell(pCell,0);
	if(!mxIsInt16(tmp_cell))
	{
		mexErrMsgTxt("Input type  is not short: you can call double input accepting version ");	
	}
    
    nR= (int) mxGetM(tmp_cell);
    *nRows = nR;
    nC = (int) mxGetN(tmp_cell);
    *nCols = nC;
    nL = (int)nCellElems;
    
	if(DEBUGG)
		mexPrintf("\n Cell Element: size %d, %d read ", nR, nC);
    
    
    //*pArray = (OperationType*) mxCalloc((nR)*(nC)*(nL), sizeof(OperationType));
	*ppArray = (OperationType*) calloc((nR)*(nC)*(nL), sizeof(OperationType));
	p_Out = *ppArray;
	if(DEBUGG)
		mexPrintf(" %d Bytes Allocated \n",(nR)*(nC)*(nL)*sizeof(OperationType));
    
	
    for (i = 0; i < nL; i++)
    {
		tmp_cell = (mxArray*) mxGetCell(pCell,i);
        cell_element_ptr = (InputType*) mxGetData(tmp_cell);
        for  (j = 0; j < nR*nC; j++)
            p_Out[i*nR*nC+j] = cell_element_ptr[j];

		//mexPrintf("tHree %d %d %d \n",p_Out[0],p_Out[1],p_Out[2]);        
		//free(cell_element_ptr);
	//mxDestroyArray(tmp_cell);
    }
	if (DEBUGG)
		mexPrintf("Voxels copied \n");
}

void array2cell(mxArray** ppCell, OperationType* pArray, int nRows, int nCols, int nLength)
{
    mxArray *tmp_cell, *pCell;
    //OperationType* cell_element_ptr ;
	OutputType* pSlice; 
    int  i = 0, j= 0; 
    
	pCell = *ppCell;
    if(!mxIsCell(pCell))
        mexErrMsgTxt("Input to the function array2cell must be a cell");
	if( nLength < 1)
		mexErrMsgTxt("nLength is < 1 ");
	
    
	if (pArray==0) 
		mexErrMsgTxt("Null Pointer pArray ");

	tmp_cell = (mxArray*) mxCreateNumericMatrix(nRows, nCols, mxOutputType, 0);
	// This is default unfortunately
	pSlice = (OutputType*) mxGetData(tmp_cell);
	for (i = 0; i < nLength; i++)
    {
		for (j = 0; j < nRows*nCols; j++)
			pSlice[j] = pArray[i*nRows*nCols+j];
		mxSetCell(pCell,i, mxDuplicateArray(tmp_cell));
    }
	
	//mxFree(tmp_cell);
	mxDestroyArray(tmp_cell);
	if(DEBUGG)
		mexPrintf("Voxels put back in the cell array \n");
}



void filter3d (OperationType* pInArray, OperationType** ppOutArray, int nRows, int nCols, int nLength, double* pFilter, int filt_row, int filt_col, int filt_dep)
{
	OperationType *pOutArray=0;
	int x=0, y=0, z =0,xc=0, yc=0, zc =0, datasize =0; 
	int x_mrg_left=0, x_mrg_right=0, y_mrg_left =0, y_mrg_right =0, 
		z_mrg_left =0, z_mrg_right =0, center =0, wnd_p =0, filt_p =0;
	double p_sum; 

	
	datasize = (nRows)*(nCols)*(nLength);	
	*ppOutArray = (OperationType*) calloc(datasize, sizeof(OperationType));
	pOutArray = *ppOutArray;
	memcpy(pOutArray, pInArray, datasize*sizeof(OperationType));

	if(DEBUGG)
		mexPrintf("\n Filtering  size %d, %d, %d array with %d %d %d size filter  \n", nRows, nCols, nLength, filt_row, filt_col, filt_dep);

	x_mrg_left = (int)floor(filt_col/2.0f); //Note that this is also left right step in the filter 
	y_mrg_left = (int)floor(filt_row/2.0f);
	z_mrg_left = (int)floor(filt_dep/2.0f);
	
	x_mrg_right = nCols-x_mrg_left;
	y_mrg_right = nRows-y_mrg_left;
	z_mrg_right = nLength- z_mrg_left;
	
	
	center = 0;
	// convention difference, I have to change the pixel addresing order.

		for (z = 0; z< nLength; z++)
		for (x = 0; x< nCols; x++)
			for (y = 0; y< nRows; y++)
			{
                //center = z*nRows*nCols + y*nCols + x;
				center = z*nRows*nCols + x*nRows + y;
                p_sum = 0.0;
				filt_p = 0; 
				for (zc = (z-z_mrg_left); zc <= (z+z_mrg_left); zc++)
				{
					for (xc = (x-x_mrg_left); xc <= (x+x_mrg_left); xc++)    
					{
						for (yc = (y-y_mrg_left); yc <= (y+y_mrg_left); yc++)
                        {
							if ((zc < 0) || (zc == nLength) || (xc < 0) || (xc == nCols) || (yc < 0) || (yc == nRows)) 
							{
								filt_p++; continue;
							}
					
							
                            //wnd_p = zc*nRows*nCols + yc*nCols + xc;
							wnd_p = zc*nRows*nCols + xc*nRows + yc;
                            p_sum+= pInArray[wnd_p]*pFilter[filt_p++];
                        }
					}
				}
                pOutArray[center] = (OperationType)floor(p_sum);
 
            }
/*
	for (z = z_mrg_left; z< z_mrg_right; z++)
		for (x = x_mrg_left; x< x_mrg_right; x++)
			for (y = y_mrg_left; y< y_mrg_right; y++)
			{
                //center = z*nRows*nCols + y*nCols + x;
				center = z*nRows*nCols + x*nRows + y;
                p_sum = 0.0;
				filt_p = 0; 
				for (zc = (z-z_mrg_left); zc <= (z+z_mrg_left); zc++)
					for (xc = (x-x_mrg_left); xc <= (x+x_mrg_left); xc++)    
						for (yc = (y-y_mrg_left); yc <= (y+y_mrg_left); yc++)
                        {
                            //wnd_p = zc*nRows*nCols + yc*nCols + xc;
							wnd_p = zc*nRows*nCols + xc*nRows + yc;
                            p_sum+= pInArray[wnd_p]*pFilter[filt_p++];
                        }
                pOutArray[center] = (OperationType)floor(p_sum);
 
            }
*/
			if(DEBUGG)
				mexPrintf("\n Filtering  Done  \n" );
	
}



void mexFunction( int nlhs, mxArray *plhs[],
int nrhs, const mxArray*prhs[] )
{
    mxArray    *p_mxCell,*p_mxCellOut=0;
  //  mxClassID  *classIDflags;
    OperationType *p_InArray=0, *p_OutArray =0;
	double * p_filter =0; 
    int nrows=0, ncols=0, nslices,  index =0;
	int nfiltrows=0, nfiltcols=0, nfiltdep =0, ndims=0,*pdims=0 ;
    
    if(nrhs!=2)
        mexErrMsgTxt("Inputs must be a cell second and a 3d Double array.");
    else if(nlhs > 1)
        mexErrMsgTxt("Too many output arguments.");
    else if(!mxIsCell(prhs[0]))
        mexErrMsgTxt("Inputs must be a cell second and a 3d Double array.");
    
	// take the pointer for the input celll  
    p_mxCell = (mxArray*)(prhs[0]);
    
	// convert it to a numeric array
    cell2array(p_mxCell, &p_InArray, &nrows, &ncols, &nslices);

	if(DEBUGG)
		mexPrintf("\n Array size %d, %d, %d read ", nrows, ncols, nslices);
	
	// take the filter 
	p_filter = mxGetPr(prhs[1]);
	ndims  = mxGetNumberOfDimensions(prhs[1]);
	if (ndims != 3) 
	{
		mexErrMsgTxt("Filter is not 3 dimensional array.");
	}
	pdims =(int*) mxGetDimensions(prhs[1]);
	nfiltrows=pdims[0];
	nfiltcols=pdims[1];
	nfiltdep =pdims[2];
	if(DEBUGG)
		mexPrintf("\n Filter size %d, %d, %d  ", nfiltrows, nfiltcols, nfiltdep);

    
    // strcmp(mxGetClassName(pm), "double"); type check
   filter3d(p_InArray, &p_OutArray, nrows, ncols, nslices, p_filter, nfiltrows, nfiltcols, nfiltdep);
   if (p_OutArray==NULL)
	   mexErrMsgTxt("\n Unexpected nullpointer ");

	   

      /* Create output a nrhs x 1 cell mxArray. */
    
    plhs[0] = mxCreateCellMatrix(nslices,1);
    p_mxCellOut =(mxArray*) (plhs[0]); 

    array2cell(&p_mxCellOut, p_OutArray, nrows, ncols, nslices);

	if (p_InArray) 
  //      mxFree(p_InArray);
       free(p_InArray);
	if (p_OutArray)
		free(p_OutArray);
    return;
 
    mexPrintf("\n Done... \n");
}

