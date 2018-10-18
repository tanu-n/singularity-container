Bootstrap: shub
From: singularityhub/ubuntu

%setup
   # make directory for test MPI program
   mkdir ${SINGULARITY_ROOTFS}/mpitestapp
   # copy test file into directory
   cp mpi_hello_world.c ${SINGULARITY_ROOTFS}/mpitestapp/
   cp get_key.sh ${SINGULARITY_ROOTFS}/mpitestapp/

%post
   apt-get update
   apt-get -y install build-essential g++ git wget

   # build openmpi
   mkdir /openmpi-3.1.2
   cd /openmpi-3.1.2
   wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
   tar xf openmpi-3.1.2.tar.gz --strip-components=1
   # disable the addition of the RPATH to compiled executables
   # this allows us to override the MPI libraries to use those
   # found via LD_LIBRARY_PATH
   ./configure --prefix=/usr/local 
   make -j 4 install
   
   export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
   export PATH=/usr/local/bin:$PATH

   cd /mpitestapp
   mpicc -o mpi_hello_world mpi_hello_world.c
   
   mkdir /go
   cd /go
   wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
   tar -C /usr/local -xzf go1.11.1.linux-amd64.tar.gz
   export PATH=$PATH:/usr/local/go/bin
   export GOPATH=/go
   go get -v go.etcd.io/etcd
   src/go.etcd.io/etcd/build
   

%environment
   # following environment variable will be available via all Singularity actmkion commands (e.g. shell, run, exec).
   LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
   export LD_LIBRARY_PATH
   PATH=/usr/local/bin:/usr/local/go/bin:$PATH
   export PATH
   GOPATH=/go
   export GOPATH
	
%runscript
   echo $LD_LIBRARY_PATH
   /mpitestapp/mpi_hello_world
    export ETCDCTL_API=3
   HOST_1=192.168.16.193
   HOST_2=192.168.16.208
   HOST_3=192.168.16.194
   ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379
   $GOPATH/bin/etcdctl --endpoints=$ENDPOINTS member list
   $GOPATH/bin/etcdctl --endpoints=$ENDPOINTS put foo bar
   $GOPATH/bin/etcdctl --endpoints=$ENDPOINTS get foo
