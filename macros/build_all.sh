set -e

cd BootROM
make
cd ../GPIO
make
cd ../RAMController
make
cd ../SID
make
cd ../SerialPorts
make
cd ../Timers
make
cd ../AS2650
make
cd ../UnusedIO
make
cd ..
