.. _ansys-sharc-mechanical:

.. include:: ../ansys/sharc-sidebar.rst

Mechanical / Map-DL
=========================

.. contents::
    :depth: 3

----------------

Ansys Mechanical is a finite element analysis (FEA) tool that enables you to analyze complex product architectures and solve difficult mechanical problems.
You can use Ansys Mechanical to simulate real world behavior of components and sub-systems, and customize it to test design variations quickly and accurately.
ANSYS Mechanical has interfaces to other pre and post processing packages supplied by ANSYS and can make use of  built in :ref:`MPI <parallel_MPI>` to utilize multiple cross node CPU and can scale to hundreds of cores.

----------------

.. include:: ../ansys/module-load-list.rst

--------------------

Interactive jobs
----------------

While using a X11 GUI forwarding supported SSH client, an interactive session can be started on ShARC with the ``qrshx`` command which supports graphical applications.
You can load an ANSYS module above and then start the ANSYS mechanical launcher program by running the ``launcher`` command.

If desired, the ANSYS Workbench GUI executable can be launched with the  ``ansyswb`` command.
To use more than a single core, you should write a batch job script and ANSYS mechanical APDL script file for submission to the batch queues.

--------------------

Batch jobs
----------

MAPDL is capable of running in both :ref:`MPI <parallel_MPI>` and :ref:`SMP <parallel_SMP>` parallel environments but will use its in-build MPI communications for both.
On ShARC, cross process communication must use the RSH protocol instead of SSH.
This necessitates the use of either the ``smp`` (up to 16 cores on a single node only) or ``mpi-rsh`` (as many cores as desired across many nodes) parallel processing environments.


Sample MPI MAPDL Scheduler Job Script
""""""""""""""""""""""""""""""""""""""""""

The following is an example batch submission script, ``mech_job.sh``, to run the mechanical executable ``mapdl`` with input file ``CrankSlot_Flexible.inp``, and carry out a mechanical simulation.
The script requests 4 cores using the MPI parallel environment with a runtime of 10 mins and 2 GB of real memory per core:

.. hint::

    * Use of the ``#$ -V`` SGE option will instruct SGE to import your current terminal environment variables to be imported - **CAUTION** - this may not be desirable.
    * Use of the ``mpi-rsh`` parallel environment to run MPI parallel jobs for Ansys is required if using more than 16 cores on ShARC.
    * The argument ``$NSLOTS`` is a Sun of Grid Engine variable which will return the requested number of cores.
    * The argument ``-mpi=INTELMPI`` instructs MAPDL to use the in-built Intel MPI communications - important for using the high performance :ref:`Omnipath networking <sharc-network-specs>` between nodes.
    * The argument ``-rsh`` tells MAPDL to use RSH instead of SSH.
    * The argument ``-sge`` forces MAPDL to recognise job submission via SGE.
    * The argument ``-sgepe`` selects the *mpi-rsh* SGE parallel environment.

.. code-block:: bash

    #!/bin/bash
    #$ -V
    #$ -cwd
    #$ -N JobName
    #$ -M joe.bloggs@sheffield.ac.uk
    #$ -m abe
    #$ -l h_rt=00:10:00
    #$ -l rmem=2G
    #$ -pe mpi-rsh 4
    module load apps/ansys/20.2/binary
    mapdl -i CrankSlot_Flexible.inp -b -np $NSLOTS -sge -mpi=INTELMPI -rsh -sgepe mpi-rsh

-----------------------

Sample SMP MAPDL Scheduler Job Script
""""""""""""""""""""""""""""""""""""""""""""

The following is an example batch submission script, ``mech_job.sh``, to run the mechanical executable ``mapdl`` with input file ``CrankSlot_Flexible.inp``, and carry out a mechanical simulation.
The script requests 4 cores using the SMP (``single node shared memory``) parallel environment with a runtime of 10 mins and 2 GB of real memory per core:

.. code-block:: bash

    #!/bin/bash
    #$ -V
    #$ -cwd
    #$ -N JobName
    #$ -M joe.bloggs@sheffield.ac.uk
    #$ -m abe
    #$ -l h_rt=00:10:00
    #$ -l rmem=2G
    #$ -pe smp 4
    module load apps/ansys/20.2/binary
    mapdl -b -np $NSLOTS -smp -i CrankSlot_Flexible.inp


Further details about how to construct batch jobs can be found on the :ref:`batch submission guide <submit-batch>` page

The job is submitted to the queue by typing:

.. code-block:: bash

    qsub mech_job.sh
