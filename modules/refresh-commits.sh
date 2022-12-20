#!/bin/sh

# for any line that contains a ##!, replace any text between double quotes with the result of the command written after ##!
cp editors_nvim.nix editors_nvim.nix_orig
awk -F "\"" 'BEGIN { OFS=FS }{ if ( $0 ~ / # #! /) { split($0, cmd,/ # #! /); cmd[2] | getline $2; }; print $0; }' editors_nvim.nix_orig > editors_nvim.nix
