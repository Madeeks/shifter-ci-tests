#!/bin/bash

####################
#build shifter
####################
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

####################
#run tests
####################
export DO_ROOT_TESTS=1
export DO_ROOT_DANGEROUS_TESTS=1

mkdir -p /tmp/imagegw /tmp/systema /tmp/systemb
cd $build_dir/src/test
../../extra/CI/test_script.sh && cd ../.. && export PATH=$PWD/imagegw/test:$PATH && PYTHONPATH=$PWD/imagegw nosetests -s --with-coverage imagegw/test
exit_code=$?
rm -rf /tmp/imagegw /tmp/systema /tmp/systemb

if [ $exit_code -eq 0 ] ; then
    echo "TESTS SUCCEDED"
else
    echo "TESTS FAILED"
fi
