# lorOS
Quadrid lorOS is an operating system which should be simple to use and install.

# This software is still pretty early in development and modifies essential parts of the system. Use this at your own risk.
## Stable Branch: uses Pantheon instead of Cutefish

## Why lorOS?
lorOS is easy to install: Just execute a setup.exe and wait. You can utilize your computer during the process, and there is no need to reboot until the system will be used.

Furthermore, lorOS offers a lot of convenience during the switch. The home directories get linked, so all of your files are already on your new system. In addition to that, lorOS automatically sets up dual-boot.

## What is lorOS based on?
We use Arch Linux as a base. While it isn't considered the most stable distro, it is easy to modify the install media which is why we chose it: We want to make it as easy as possible to contribute.

## What is lorOS compatible with?
lorOS **should** be compatible with all computers that fulfill the following requirements:
 
 1) UEFI Booted Windows
 2) GPT on the disk with the C:\ Drive
 3) The disk with the C:\ Drive has the number 0
 4) No Bitlocker or similar
 5) Enough free space on the C:\ Drive
 6) Linux-Compatible usernames without spaces
 7) Less than 127 Partitions on the Disk with the C:\ Drive ;)
 8) x86_64 Architecture
 
 ## How to install lorOS on your Windows computer
Method 1: Use the installer which can be downloaded here (we haven't made it yet) and continue with the Secure Boot section

Method 2:
1) Download the newest release from [here](https://github.com/Quadrid/lorOS/releases)
2) Execute run.bat with administrative privileges to start the installation
3) Continue with the Secure Boot section

Method 3:
1) Download this repository
2) Build the iso on a linux system with arch-install-scripts installed by running `bash build.sh` in the downloaded directory
3) Download grub for Windows from [Here](https://ftp.gnu.org/gnu/grub/grub-2.06-for-windows.zip) and extract it into a directory with the name grub in the downloaded directory
4) Install QEMU for Windows to a directory named qemu in the downloaded directory
5) Execute run.bat with administrative privileges to start the installation
6) Continue with the Secure Boot section

## Secure Boot
On most compatible computers, Secure Boot is enabled by default. This is not an issue anymore, but you'll have to do some extra steps if Secure Boot is enabled.

After the Installation has finished and you have rebooted, you might see an error message. Press the enter key to get to a menu with a few choices. Here, you have to navigate to "Enroll Hash" with your arrow keys and press enter to confirm, then select "loader.efi", select "yes", and then "Reboot System". After this procedure, the newly installed system should start.

## Mac or Linux computers
We do not currently have support for macs or linux computers. The goal of this software is to simplify the switch to a linux-based system for windows users.
