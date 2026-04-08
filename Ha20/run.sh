#!/bin/bash

cores=16
solver=mhdEpotMultiRegionFoam

blockMesh -region fluid  2>&1 | tee log.blockMesh_fluid
blockMesh -region walls  2>&1 | tee log.blockMesh_walls

if [[ ! $cores -eq 1 ]]
then
  decomposePar -allRegions  2>&1 | tee log.decomposePar
  mpirun -np $cores $solver -parallel  2>&1 | tee log.$solver
	reconstructPar 2>&1 | tee log.reconstructPar
else
	$solver 2>&1 | tee log.$solver
fi

touch foam.foam
