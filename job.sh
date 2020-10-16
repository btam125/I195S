#!/bin/bash
#SBATCH --job-name		W_I195S
#SBATCH --partition 		mpi-normal
#SBATCH --nodes			1
#SBATCH --tasks-per-node	40
#SBATCH --mem			10G
#SBATCH --time			72:00:00
#SBATCH --output        	W_I195S.%j.out
#SBATCH --error         	W_I195S.%j.err
#SBATCH --signal=B:USR1@120

source /etc/profile
source /etc/profile.d/modules.sh

module add gcc/6.5.0                            
module add cuda/9.2.148
module add openmpi/4.0.0/gcc/6.5.0                      
module add gromacs/2020-ompi-4.0.0/gcc/6.5.0               

NP=$(($SLURM_NTASKS_PER_NODE * $SLURM_JOB_NUM_NODES))
mpirun -np $NP --report-bindings --mca pml ucx --mca osc ucx  gmx_mpi mdrun -v -cpi state.cpt 

# define the handler function
# note that this is not executed here, but rather
# when the associated signal is sent

your_cleanup_function()
{
    echo "function your_cleanup_function called at $(date)"
    # do whatever cleanup you want here
    pkill -u yb87625
}

# call your_cleanup_function once we receive USR1 signal
trap 'your_cleanup_function' USR1

