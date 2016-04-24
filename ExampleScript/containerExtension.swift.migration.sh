find . -type f | grep ".swift" > swiftindex.temp

while IFS= read -r filename
do
    LC_ALL=C sed -i "" \
        -e s/.resolve\(PersonType.self,\ name:\ \"initializer\"\)\!/.resolveInjectablePerson_initializer\(\)/g \
        -e s/.register\(PersonType.self,\ name:\ \"initializer\"\)/.registerInjectablePerson_initializer/g \
        -e s/.resolve\(PersonType.self\)\!/.resolveInjectablePerson\(\)/g \
        -e s/.register\(PersonType.self\)/.registerInjectablePerson/g \
        -e s/.resolve\(PersonType.self\)\!/.resolvePersonType\(\)/g \
        -e s/.register\(PersonType.self\)/.registerPersonType/g \
        -e s/.resolve\(PersonType.self\)\!/.resolveInjectablePerson\(argumentName:\ ArgumentType\)/g \
        -e s/.register\(PersonType.self\)/.registerInjectablePerson/g \
        -e s/.resolve\(PersonType.self\)\!/.resolveInjectablePerson\(argumentName:\ ArgumentType,\ argumenttypewithoutspecificname:\ ArgumentTypeWithoutSpecificName,\ title:\ String,\ string:\ String\)/g \
        -e s/.register\(PersonType.self\)/.registerInjectablePerson/g \
        -e s/.resolve\(PersonType.self,\ name:\ \"initializer\"\)\!/.resolveInjectablePerson_initializer\(argumentName:\ ArgumentType,\ argumenttypewithoutspecificname:\ ArgumentTypeWithoutSpecificName,\ title:\ String,\ string:\ String\)/g \
        -e s/.register\(PersonType.self,\ name:\ \"initializer\"\)/.registerInjectablePerson_initializer/g \
     "$filename"
done < swiftindex.temp
rm swiftindex.temp
