# shifter-ci-tests
A reproducible vagrant-based environment to run the shifter's CI tests.

## How to configure it
First you need to have somewhere on your machine a local copy of the shifter's repository.
Then you need to modify the Vagrantfile as shown below.
```
config.vm.synced_folder "<path of the repository on your machine>", "/shared-folders/shifter-repository"
```
The above configuration will share your local copy of the repository with the virtual machine.

## How to use it
Create the virtual machine and provision it:
```sh
cd <project root folder> # i.e. where vagrant file is located
vagrant up
```
Ssh to the virtual machine:
```sh
vagrant ssh
```
Build shifter and run the CI tests:
```sh
/shared-folders/scripts/build_shifter_and_run_tests.sh
```

## Details
Tested on Ubuntu 16.04 with Vagrant 1.8.1 and Virtualbox 5.0.18.

## Troubleshooting
- The CI tests are not independent (sigh!), that is the results are not guaranteed to be consistent when running subsets of the tests in different orders. So far I experienced sporadic failures of the test imagegwapi_test.py:GWTestCase.test_autoexpire. The test passed when the entire test suite was executed though.
