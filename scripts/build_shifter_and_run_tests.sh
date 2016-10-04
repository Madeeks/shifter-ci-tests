#!/bin/bash

check_return_code()
{
    exit_code=$1
    if [ $exit_code -eq 0 ] ; then
        echo "TESTS SUCCEDED"
    else
        echo "TESTS FAILED"
        exit 1
    fi
}

#build shifter
build_dir=$HOME/shifter-build
mkdir -p $build_dir
rsync -a --progress /shared-folders/shifter-repository/ $build_dir
cd $build_dir
cp imagegw/test.json.example test.json
rm imagegw/test/sha256sum

num_of_processors=$(grep -c ^processor /proc/cpuinfo)
num_of_processors=$((num_of_processors-2))
num_of_processors=$((num_of_processors>1?num_of_processors:1))

./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc/shifter --disable-staticsshd
MAKEFLAGS="-j$num_of_processors" make
MAKEFLAGS="-j$num_of_processors" make check
#make install

#run udiRoot tests
export DO_ROOT_TESTS=1
export DO_ROOT_DANGEROUS_TESTS=1
cd $build_dir/src/test
../../extra/CI/test_script.sh
exit_code=$?
check_return_code $exit_code

#run imagegw tests
mkdir -p /tmp/imagegw /tmp/systema /tmp/systemb
cd ../..
export ORIGPATH=$PATH
export PATH=$PWD/imagegw/test:$PATH
export PYTHONPATH=$PWD/imagegw
nosetests -s --with-coverage imagegw/test
exit_code=$?
check_return_code $exit_code
export PATH=$ORIGPATH
export BUILDDIR=$(pwd)
rm -rf /tmp/imagegw /tmp/systema /tmp/systemb

#run integration tests
export PYTHONPATH=$PWD/imagegw
cd /
$BUILDDIR/extra/CI/integration_test.sh
exit_core=$?
check_return_code $exit_code
