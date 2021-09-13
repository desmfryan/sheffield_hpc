#!/bin/bash
#$ -cwd
#$ -M joe.bloggs@sheffield.ac.uk
#$ -m abe
#$ -l h_rt=02:00:00
#$ -l rmem=2G
#$ -pe smp 8
#$ -N gdal-install
##$ -q cstest.q
##$ -P cstest
#$ -j yes

#Naturally this script is for use on SGE clusters only.
#Suggested resource values above should be sane and work.
#Script written by JMoore 06-09-2021 @ The University of Sheffield IT Services.

#Notes:

########################  Options and version selections  #########################
###################################################################################


#Define Names and versions
PACKAGENAME=gdal
PACKAGEVER=3.3.1
GCCVER=8.2
CMAKEVER=3.17.1

FILENAME=$PACKAGENAME-$PACKAGEVER.tar.gz
URL="https://github.com/OSGeo/$PACKAGENAME/releases/download/v$PACKAGEVER/$FILENAME"
#   https://github.com/OSGeo/gdal/releases/download/v3.3.1/gdal-3.3.1.tar.gz


# Signal handling for failure
handle_error () {
    errcode=$? # save the exit code as the first thing done in the trap function 
    echo "Error: $errorcode" 
    echo "Command: $BASH_COMMAND" 
    echo "Line: ${BASH_LINENO[0]}"
    exit $errcode  # or use some other value or do return instead 
}
trap handle_error ERR

#Start the main work of the script
echo "Running install script to make Package: "  $PACKAGENAME " Version: "  $PACKAGEVER 


#Setup calculated variables
INSTALLDIR=/usr/local/packages/libs/$PACKAGENAME/${PACKAGEVER}/gcc-$GCCVER-cmake-$CMAKEVER/
SOURCEDIR=$INSTALLDIR/src

MODULEDIR=/usr/local/modulefiles/libs/$PACKAGENAME/${PACKAGEVER}/
MODULEFILENAME=gcc-$GCCVER-cmake-$CMAKEVER

FULLPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")

#Load Modules
module purge
module load dev/gcc/$GCCVER
module load dev/cmake/$CMAKEVER/gcc-$GCCVER
module load apps/doxygen/1.9.1/gcc-$GCCVER-cmake-$CMAKEVER
module load libs/proj/7.1.0/gcc-8.2.0
module load libs/sqlite/3.32.3/gcc-8.2.0

echo "Loaded Modules: " $LOADEDMODULES


#Make directories after clearing out.

if [ -d $INSTALLDIR ]
then
    rm -r $INSTALLDIR
    echo "Clearing existing install directory."
fi

mkdir -p $INSTALLDIR
mkdir -p $SOURCEDIR

echo "Install Directory: "  $INSTALLDIR
echo "Source Directory: " $SOURCEDIR


#Go to the source directory
cd $SOURCEDIR

#Download source and extract
echo "Download Source"


if test -f "$FILENAME"; then
    rm -r $PACKAGENAME-$PACKAGEVER
    tar -zxf  $FILENAME
else
    wget $URL
    tar -zxf  $FILENAME
fi

cd $PACKAGENAME-$PACKAGEVER


#Configure

./configure --prefix=$INSTALLDIR --with-sqlite3=/usr/local/packages/libs/sqlite/3.32.3/gcc-8.2.0

#Clean
echo "Make precleaning:"
make -j $NSLOTS clean

#Make
echo "Making:"
make -j $NSLOTS
#make -j $NSLOTS man


#Install
echo "Make installing:"
make -j $NSLOTS install
#make -j $NSLOTS install-man INST_MAN=$INSTALLDIR/share/man

#Echo the loaded modules used to compile the installed directory
#Splits on colon sends each element to new line
echo $LOADEDMODULES | awk 'BEGIN{RS=":"}{$1=$1}1' >> $INSTALLDIR/compiler_loaded_modules_list

#Copy the used install script to install directory
cp $FULLPATH $INSTALLDIR/install_script.sge

################################## Begin adding the module file ###################################
mkdir -p $MODULEDIR

if test -f "$MODULEDIR$MODULEFILENAME"; then
    rm $MODULEDIR$MODULEFILENAME #Remove it if it already exists due to prior failure to install.
    touch $MODULEDIR$MODULEFILENAME
else
    touch $MODULEDIR$MODULEFILENAME
fi


#Dashes need to be removed from package names or module files will break.
PACKAGENAME=${PACKAGENAME//-/_}


################################ Add the start of the module file #################################

cat <<EOF >>$MODULEDIR$MODULEFILENAME
#%Module1.0#####################################################################
##
## $PACKAGENAME $PACKAGEVER module file
##

## Module file logging
source /usr/local/etc/module_logging.tcl
##

proc ModulesHelp { } {
        puts stderr "Makes $PACKAGENAME $PACKAGEVER available"
}

module-whatis   "Makes $PACKAGENAME $PACKAGEVER available"

# Add required module loads

EOF

################################# Now add the needed module loads #################################

sed 's/.*/module load &/' $INSTALLDIR/compiler_loaded_modules_list >> $MODULEDIR$MODULEFILENAME


###################### Now add the Package root directory variable and path #######################

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set package root directory
set ROOT_DIR_$PACKAGENAME  $INSTALLDIR

EOF

NESTEDROOTDIRVAR=\$ROOT_DIR_$PACKAGENAME

#################################### Now add the PATH if needed ###################################

if [ -d $INSTALLDIR/bin ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set executable path
prepend-path PATH        		 $NESTEDROOTDIRVAR/bin

EOF
fi

################################# Now add the LIBRARIES if needed #################################

if [ -d $INSTALLDIR/lib ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set library paths
prepend-path LD_LIBRARY_PATH 	 $NESTEDROOTDIRVAR/lib
prepend-path LIBRARY_PATH 	     $NESTEDROOTDIRVAR/lib

EOF
fi

if [ -d $INSTALLDIR/lib64 ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set 64 bit library paths
prepend-path LD_LIBRARY_PATH 	 $NESTEDROOTDIRVAR/lib64
prepend-path LIBRARY_PATH 	     $NESTEDROOTDIRVAR/lib64

EOF
fi

################################# Now add the C Pathing if needed #################################

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set CMAKE PREFIX PATH
prepend-path CMAKE_PREFIX_PATH 	 $NESTEDROOTDIRVAR

EOF

if [ -d $INSTALLDIR/include ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set CMAKE INCLUDES
prepend-path CPLUS_INCLUDE_PATH  $NESTEDROOTDIRVAR/include
prepend-path CPATH 		         $NESTEDROOTDIRVAR/include

EOF
fi
################################# Now add the PKG_CONFIG if needed#################################

if [ -d $INSTALLDIR/lib/pkgconfig ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set PKG_CONFIG_PATH
prepend-path PKG_CONFIG_PATH     $NESTEDROOTDIRVAR/lib/pkgconfig

EOF

fi

if [ -d $INSTALLDIR/lib64/pkgconfig ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set 64bit PKG_CONFIG_PATH
prepend-path PKG_CONFIG_PATH     $NESTEDROOTDIRVAR/lib64/pkgconfig

EOF

fi


if [ -d $INSTALLDIR/share/pkgconfig ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set share PKG_CONFIG_PATH
prepend-path PKG_CONFIG_PATH     $NESTEDROOTDIRVAR/share/pkgconfig

EOF

fi

################################# Now add the ACLOCAL_PATH if needed#################################
if [ -d $INSTALLDIR/share/aclocal ]
then

cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set share ACLOCAL_PATH
prepend-path ACLOCAL_PATH     $NESTEDROOTDIRVAR/share/aclocal

EOF

fi


#################################  Custom ENV VARs in module needed  #################################
cat <<EOF >>$MODULEDIR$MODULEFILENAME

# Set Man path
prepend-path MANPATH $NESTEDROOTDIRVAR/share/man/

EOF

################################# Now chmod the directories properly #################################

chown $USER:hpc_app-admins $INSTALLDIR
chmod 775 -R $INSTALLDIR
chown $USER:hpc_app-admins $MODULEDIR$MODULEFILENAME
chmod 775 $MODULEDIR$MODULEFILENAME

ELOG=${SGE_O_WORKDIR}/${JOB_NAME}.e${JOB_ID}
OLOG=${SGE_O_WORKDIR}/${JOB_NAME}.o${JOB_ID}

if test -f "$ELOG"; then
    echo "$ELOG exists. Copying to install dir."
    cp $ELOG $INSTALLDIR
fi

if test -f "$OLOG"; then
    echo "$OLOG exists. Copying to install dir."
    cp $OLOG $INSTALLDIR
fi
