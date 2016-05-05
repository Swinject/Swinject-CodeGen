#/bin/sh
../swinject_codegen -i example.csv -o containerExtension.swift
../swinject_codegen -i example.yml -o containerExtension2.swift
../swinject_codegen -i example.csv  -c
../swinject_codegen -i example.yml  -c
../swinject_codegen -i example.csv.yml -o containerExtension3.swift
../swinject_codegen -i example.yml.csv -o containerExtension4.swift
