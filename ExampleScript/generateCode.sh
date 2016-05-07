#/bin/sh
../codegen/swinject_codegen -i example.csv -o containerExtension.swift
../codegen/swinject_codegen -i example.yml -o containerExtension2.swift
../codegen/swinject_codegen -i example.csv  -c
../codegen/swinject_codegen -i example.yml  -c
../codegen/swinject_codegen -i example.csv  -m
../codegen/swinject_codegen -i example.yml  -m
../codegen/swinject_codegen -i example.csv.yml -o containerExtension3.swift
../codegen/swinject_codegen -i example.yml.csv -o containerExtension4.swift
