#!/bin/bash
# dependency: arch-install-scripts
sudo rm -rf .workdir
sudo rm -rf .outdir
mkdir .workdir
mkdir .outdir
sudo mkarchiso -v -w .workdir -o .outdir archiso
mv .outdir/* ./install.iso
sudo rm -rf .workdir
sudo rm -rf .outdir
