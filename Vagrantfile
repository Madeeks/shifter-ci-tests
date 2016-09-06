
$provisioning_script = <<SCRIPT
#provision shifter dependencies
sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ precise universe multiverse"
sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get update -qq

#note: running the following apt-get commands as one liner used to generate more error messages such as
#'Failed to fetch http://.../blahblah.deb  403  Forbidden [IP: 91.189.88.152 80]'
sudo apt-get install -qq libjson-c2 
sudo apt-get install -qq libjson-c-dev 
sudo apt-get install -qq libmunge2
sudo apt-get install -qq libmunge-dev
sudo apt-get install -qq libcurl4-openssl-dev
sudo apt-get install -qq autoconf
sudo apt-get install -qq autoconf
sudo apt-get install -qq automake
sudo apt-get install -qq libtool
sudo apt-get install -qq curl
sudo apt-get install -qq make
sudo apt-get install -qq valgrind
sudo apt-get install -qq xfsprogs
sudo apt-get install -qq squashfs-tools
sudo apt-get install -qq mongodb
sudo apt-get install -qq redis-server
sudo apt-get install -qq python-dev
sudo apt-get install -qq python-pip
sudo apt-get install -qq python-nose

pip install -r /shared-folders/shifter-repository/imagegw/requirements.txt
pip install coverage
pip install cpp-coveralls

directory_coveralls=$(dirname $(which coveralls) )
mv $directory_coveralls/coveralls $directory_coveralls/cpp-coveralls

pip install coveralls
pip install coveralls-merge
SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "scripts", "/shared-folders/scripts"
  config.vm.synced_folder "../shifter", "/shared-folders/shifter-repository"
  config.vm.provision "shell", inline: $provisioning_script
end
