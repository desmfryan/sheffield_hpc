VASP
====

.. sidebar:: VASP

   :Version: 5.4.1 (05Feb16)
   :Dependencies: Fortran and C compilers, an implementation of MPI, numerical libraries BLAS, LAPACK, ScaLAPACK, FFTW. Modules for Intel compiler 2019.5.281, Intel MPI 2019.5.281 and Intel MKL 2019b loaded.
   :URL: https://www.vasp.at/
   :Documentation: https://www.vasp.at/documentation


The Vienna Ab initio Simulation Package (VASP) is a computer program for atomic scale materials modelling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.


Usage
-----

VASP 5.4.1 can be activated using the module file::

    module load VASP/5.4.1-intel-2019b

The VASP executables are ``vasp_std``, ``vasp_gam`` and ``vasp_ncl``.

**Important note:** Only licensed users of VASP are entitled to use the code; refer to VASP's website for license details: https://www.vasp.at/index.php/faqs. Access to VASP on Bessemer is restricted to members of the unix group ``hpc_vasp``.
To be added to this group, please contact ``research-it@sheffield.ac.uk`` and provide evidence of your eligibility to use VASP.


Batch jobs
----------

Users are encouraged to write their own batch submission scripts. The following is an example batch submission script, ``my_job.sh``, to run ``vasp_std`` and which is submitted to the queue by typing ``qsub my_job.sh``. ::

    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=4
    #SBATCH --mem=4000
    #SBATCH --time 00:30:00
    #SBATCH --job-name=VASPTEST
    #SBATCH --output=VASPTEST.job
    #SBATCH --mail-user=username@sheffield.ac.uk
    #SBATCH --mail-type=ALL

    module load VASP/5.4.1-intel-2019b
    mpirun -np 4 vasp_std

The script requests 4 cores using  Intel MPI with a runtime of 30 mins and 4 GB of real memory.


Installation notes
------------------


VASP 5.4.1 (05Feb16) was installed using Easybuild, build details can be found in ``/usr/local/packages/live/eb/VASP/5.4.1-intel-2019b/easybuild``

The module file is 
:download:`/usr/local/modulefiles/live/eb/all/VASP/5.4.1-intel-2019b </bessemer/software/modulefiles/VASP/5.4.1/5.4.1-intel-2019b>`.

The VASP 5.4.1 installation was tested by running a batch job using the ``my_job.sh`` batch script, above, and the input for the "O atom" example (https://cms.mpi.univie.ac.at/wiki/index.php/O_atom) from the online VASP tutorials (https://cms.mpi.univie.ac.at/wiki/index.php/VASP_tutorials). 