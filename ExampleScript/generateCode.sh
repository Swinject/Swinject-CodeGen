#/bin/sh
../swinject_cg -i example.csv -o containerExtension.swift
../swinject_cg -i example.yml -o containerExtension2.swift
../swinject_cg -i example.csv  -c
../swinject_cg -i example.yml  -c
../swinject_cg -i example.csv.yml -o containerExtension3.swift
../swinject_cg -i example.yml.csv -o containerExtension4.swift
