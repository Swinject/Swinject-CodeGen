#/bin/sh
../bin/swinject_codegen -i example.csv -o containerExtension.swift
../bin/swinject_codegen -i example.yml -o containerExtension2.swift
../bin/swinject_codegen -i example.csv  -c -o example.csv.yml
../bin/swinject_codegen -i example.yml  -c -o example.yml.csv
../bin/swinject_codegen -i example.csv  -m
../bin/swinject_codegen -i example.yml  -m
../bin/swinject_codegen -i example.csv.yml -o containerExtension3.swift
../bin/swinject_codegen -i example.yml.csv -o containerExtension4.swift
