REM get locale and save it
powershell -Command "(Get-WinSystemLocale | Select-String -Pattern '-').toString().Replace('-', '_')" > vda
REM extend all parts and make sure there aren't more than 10, then shrink the c:\ volume
diskpart /s diskpart1.script && exit 1 || diskpart /s diskpart2.script || exit 1
REM shrink 512MB parts as they would conflict with the lorOS ESP
powershell -Command "ForEach ($line in $($(echo list` volume | diskpart | Select-String -Pattern '512 MB'.toString()) -split '`r`n')) { echo ('select volume ' + $line.Split('')[3] + '`nshrink desired=4') | diskpart }"
REM install lorOS
qemu\qemu-system-x86_64 -cdrom install.iso -drive file=\\.\PHYSICALDRIVE0,format=raw -drive file=vda,if=virtio -drive file=vdb,if=virtio -drive file=vdc,if=virtio -drive file=vdd,if=virtio -drive file=vde,if=virtio -m 2G -boot order=d -bios uefi-bios.bin -display none
REM assign another letter to the o volume as we need the o letter
powershell -Command "echo select` volume` o`nassign` letter=r | diskpart"
REM register the bootloader
powershell -executionpolicy bypass -file assign-esp-letter.ps1
copy O:\EFI\lorOS\grubx64.efi O:\grubx64.efi.bak
grub\grub-install.exe --target=x86_64-efi --efi-directory=O: --bootloader-id=lorOS
move /Y O:\grubx64.efi.bak O:\EFI\lorOS\grubx64.efi
diskpart /s diskpart3.script
