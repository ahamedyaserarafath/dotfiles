Installed ubuntu with LVM(whole disk) and now trying to install windows on the same machine without affecting the resource and data.

Below steps helps to solve the same.

Note: If root volume is mounted in lvm, its recommened to use LiveUSB of Ubuntu.
1. First need to resize the logical volume use command or install system-config-lvm.
```
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
sudo apt-get update
sudo apt-get install system-config-lvm
```
Once it is installed, run the program, select the logical volume you want to change in the left panel, click 'Edit Properties'.
Now change the resize as you wish!

2. Now need to resize the physical volume.

check pvs segments using the below command.
```
sudo pvs -v --segments /dev/sda3 
```
output will be similar like this means we want to move those extents to the beginning of the device or another device using ```pvmove``` command.
```
ubuntu@ubuntu:~$ sudo pvs -v --segments /dev/sda3 
    Using physical volume(s) on command line.
    Wiping cache of LVM-capable devices
  PV         VG        Fmt  Attr PSize   PFree   Start  SSize  LV     Start Type   PE Ranges              
  /dev/sda3  ubuntu-vg lvm2 a--  930.29g 579.34g      0  89600 root       0 linear /dev/sda3:0-89599      
  /dev/sda3  ubuntu-vg lvm2 a--  930.29g 579.34g  89600 148311            0 free                          
  /dev/sda3  ubuntu-vg lvm2 a--  930.29g 579.34g 237911    244 swap_1     0 linear /dev/sda3:237911-238154

```
Below command helps to move the segments.
```
ubuntu@ubuntu:~$ sudo pvmove --alloc anywhere /dev/sda3:237911-238154
  /dev/sda3: Moved: 0.0%
  /dev/sda3: Moved: 48.8%
  /dev/sda3: Moved: 95.1%
  /dev/sda3: Moved: 100.0%
```
Confirm the segments are moved without any error.
```
ubuntu@ubuntu:~$ sudo pvs -v --segments /dev/sda3 
    Using physical volume(s) on command line.
    Wiping cache of LVM-capable devices
  PV         VG        Fmt  Attr PSize   PFree   Start SSize  LV     Start Type   PE Ranges            
  /dev/sda3  ubuntu-vg lvm2 a--  930.29g 579.34g     0  89600 root       0 linear /dev/sda3:0-89599    
  /dev/sda3  ubuntu-vg lvm2 a--  930.29g 579.34g 89600    244 swap_1     0 linear /dev/sda3:89600-89843
  /dev/sda3  ubuntu-vg lvm2 a--  930.29g 579.34g 89844 148311            0 free         
````  

Finally we are set and now going to resize the physical volume, we can either use gparted or command line

```
sudo lvm pvresize -v --setphysicalvolumesize 423361536K /dev/sda3
```

In the above case i reduced to 500GB

Awesome!! if you reached these setps.

4. Now create the NTFS partition using disk utility and go ahead with windows installation with custom mode.

After successful installation the Windows bootloader replaces the grub. So, when Windows boots, you won’t see the grub menu to choose Ubuntu. So, Next you need to install grub again for Ubuntu.

5. Install Grub for Ubuntu

To install and fix grub, you need LiveCD or LiveUSB of Ubuntu.
Once you load Live Ubuntu, Open Terminal and fire following commands to install boot-repair and let it fix the Grub.

```
sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt-get update
sudo apt-get install -y boot-repair && boot-repair
```
After installation, boot-repair will get automatically launched.
Make sure to select “recommended repair” option to repair grub. Reboot.

Thats it!!! Done and dusted.

You have windows and ubuntu side by side.





