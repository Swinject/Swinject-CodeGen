# Swinject Code Generation

I would call it a very elaborated proof of concept, though we use it in production atm.
We are open for every kind of feedback, improvements of the generated code/templates, discussion of the input format etc.

## TLDR;

We propose a method to get rid of duplicate use of class values and namestrings, by generating explicit functions for registering and resolving.
Doing this, we also can generate typed tuples to use when resolving, thus allowing better documented and less error-prone code.

## Installation

We aim to support carthage in the near future

### Cocoapods

Add

```
pod 'Swinject-CodeGen',  :git => 'https://github.com/Swinject/Swinject-CodeGeneration.git'
```

to your podfile.

## Integration
1. Define your dependencies in a .csv or .yml file (see below and example file)
2. Add a call to generate the code as build script phase:

```Shell
$PODS_ROOT/Swinject-CodeGen/swinject_codegen -i baseInput.csv -o extensions/baseContainerExtension.swift
```

3. Add the generated file (here: `extensions/baseContainerExtension.swift`) to xcode
4. Repeat if you need to support multiple targets/have multiple input files.

The code is then generated at every build run.

## The Issue

We love using swinject for dependency injection.
However, we would like to stay to the DRY principle and really love types.
When using swinject, lots of duplicate definitions appear, whenever we do a

```Swift
container.register(PersonType.self, name: "initializer") { r in
    InjectablePerson(pet: r.resolve(AnimalType.self)!)
}

let initializerInjection = container.resolve(PersonType.self, name:"initializer")!
```

the tuple (PersonType.self, name:"initializer") becomes very redundant across the code.

Furthermore, when using arguments, as done in

```Swift
container.register(AnimalType.self) { _, name in Horse(name: name) }
let horse1 = container.resolve(AnimalType.self, argument: "Spirit") as! Horse
```

the `argument: "Spirit"` part is not strictly typed when calling it.

We propose a solution to both these problems by using CodeGeneration

## Input Format
Input can be given as .csv or .yml

The call
```
./swinject_codegen -i example.csv -c
```

can be used to convert example.csv into example.csv.yml (also works for .yml).

### CSV

#### Basic Structure

Our basic csv structure is defined as follows:

```CSV
SourceClassName; TargetClassName; Identifier; Argument 1 ... 9
```

The example above would translate to

```CSV
PersonType; InjectablePerson; initializer
```

to generate both a `registerPersonType_initializer` and a `resolvePersonType_initializer` function.

See the examples below for more examples.

We decided to use `;` as delimiter instead of `,` to allow the use of tuples as types.

#### Additional Commands
The ruby parser allows using  `//` and `#` for comments.
Empty lines are ignored and can be used for grouping.
`#ADD_DEPENDENCY <dependency>` and `# ADD_DEPENDENCY <dependency>` can be used to specify dependencies, e.g. `import KeychainAccess`

### YML

Example for a .yml definition:
```yml
---
:DEPENDENCIES:
  - ADependency
:DEFINITIONS:
- :baseClass: PersonType
  :targetClass: InjectablePerson
  :targetClassName: InjectablePerson
  :name: initializer
- :baseClass: PersonType
  :targetClass: InjectablePerson
  :targetClassName: InjectablePerson
- :baseClass: PersonType
  :targetClass: PersonType
  :targetClassName: PersonType
- :baseClass: AnotherPersonType
  :targetClass: AnotherPersonType
  :targetClassName: AnotherPersonType
- :baseClass: PersonType
  :targetClass: InjectablePerson
  :targetClassName: InjectablePerson
  :arguments:
  - :argumentName: argumentName
    :argumentType: ArgumentType
- :baseClass: PersonType
  :targetClass: InjectablePerson
  :targetClassName: InjectablePerson
  :arguments:
  - :argumentName: argumentName
    :argumentType: ArgumentType
  - :argumentName: argumenttypewithoutspecificname
    :argumentType: ArgumentTypeWithoutSpecificName
  - :argumentName: title
    :argumentType: String
  - :argumentName: string
    :argumentType: String
- :baseClass: PersonType
  :targetClass: InjectablePerson
  :targetClassName: InjectablePerson
  :name: initializer
  :arguments:
  - :argumentName: argumentName
    :argumentType: ArgumentType
  - :argumentName: argumenttypewithoutspecificname
    :argumentType: ArgumentTypeWithoutSpecificName
  - :argumentName: title
    :argumentType: String
  - :argumentName: string
    :argumentType: String
```

## Generation Examples


### Example A: Same class as source and target

#### Input
```CSV
PersonType; PersonType
```

#### Output
```Swift
import Swinject
extension Resolvable {
    func resolvePersonType() -> PersonType {
        return self.resolve(PersonType.self)!
    }

    func registerPersonType(registerClosure: (resolver: ResolverType) -> (PersonType)) -> ServiceEntry<PersonType> {
        return (self as! Container).register(PersonType.self, factory: registerClosure)
    }
}
```

### Example B: Different source and target

#### Input
```CSV
PersonType; InjectablePerson
```

#### Output
```Swift
import Swinject
extension Resolvable {

    func resolveInjectablePerson() -> InjectablePerson {
        return self.resolve(PersonType.self)! as! InjectablePerson
    }

    func registerInjectablePerson(registerClosure: (resolver: ResolverType) -> (InjectablePerson)) -> ServiceEntry<PersonType> {
        return (self as! Container).register(PersonType.self, factory: registerClosure)
    }
}
```

### Example C: Different source and target class with name

#### Input
```CSV
PersonType; InjectablePerson; initializer
```

#### Output
```Swift
import Swinject
extension Resolvable {

    func resolveInjectablePerson_initializer() -> InjectablePerson {
        return self.resolve(PersonType.self, name: "initializer")! as! InjectablePerson
    }

    func registerInjectablePerson_initializer(registerClosure: (resolver: ResolverType) -> (InjectablePerson)) -> ServiceEntry<PersonType> {
        return (self as! Container).register(PersonType.self, name: "initializer", factory: registerClosure)
    }

}
```

### Example D: Different source and target with a single, explicitly named argument
#### Input
```CSV
PersonType; InjectablePerson; ; argumentName:ArgumentType
```

#### Output
```Swift
import Swinject
extension Resolvable {
    func resolveInjectablePerson(argumentName: ArgumentType) -> InjectablePerson {
        return self.resolve(PersonType.self, argument: argumentName)! as! InjectablePerson
    }

    func registerInjectablePerson(registerClosure: (resolver: ResolverType, argumentName: ArgumentType) -> (InjectablePerson)) -> ServiceEntry<PersonType> {
        return (self as! Container).register(PersonType.self, factory: registerClosure)
    }
}
```

### Example E: Different source and target with multiple arguments, both explicitly named and not
If no explicit name is given, the lowercase type is used as argumentname.

#### Input
```CSV
PersonType; InjectablePerson; ; argumentName:ArgumentType; ArgumentTypeWithoutSpecificName; title:String; String
```

#### Output
```Swift
import Swinject
extension Resolvable {
    func resolveInjectablePerson(argumentName: ArgumentType, argumenttypewithoutspecificname: ArgumentTypeWithoutSpecificName, title: String, string: String) -> InjectablePerson {
        return self.resolve(PersonType.self, arguments: (argumentName, argumenttypewithoutspecificname, title, string))! as! InjectablePerson
    }

    func registerInjectablePerson(registerClosure: (resolver: ResolverType, argumentName: ArgumentType, argumenttypewithoutspecificname: ArgumentTypeWithoutSpecificName, title: String, string: String) -> (InjectablePerson)) -> ServiceEntry<PersonType> {
        return (self as! Container).register(PersonType.self, factory: registerClosure)
    }
}
```

### Example F:  Different source and target with name with multiple arguments, both explicitly named and not
#### Input
```CSV
PersonType; InjectablePerson; initializer; argumentName:ArgumentType; ArgumentTypeWithoutSpecificName; title:String; String
```

#### Output
```Swift
import Swinject
extension Resolvable {
    func resolveInjectablePerson_initializer(argumentName: ArgumentType, argumenttypewithoutspecificname: ArgumentTypeWithoutSpecificName, title: String, string: String) -> InjectablePerson {
        return self.resolve(PersonType.self, name: "initializer", arguments: (argumentName, argumenttypewithoutspecificname, title, string))! as! InjectablePerson
    }

    func registerInjectablePerson_initializer(registerClosure: (resolver: ResolverType, argumentName: ArgumentType, argumenttypewithoutspecificname: ArgumentTypeWithoutSpecificName, title: String, string: String) -> (InjectablePerson)) -> ServiceEntry<PersonType> {
        return (self as! Container).register(PersonType.self, name: "initializer", factory: registerClosure)
    }
}
```

## Usage Examples

Using the examples given at the beginning, we can now instead of

```Swift
container.register(PersonType.self, name: "initializer") { r in
    InjectablePerson(pet: r.resolve(AnimalType.self)!)
}

let initializerInjection = container.resolve(PersonType.self, name:"initializer")!
```

write:

```Swift
container.registerPersonType_initializer { r in
    InjectablePerson(pet: r.resolve(AnimalType.self)!)
}

let initializerInjection = container.resolvePersonType_initializer()
```

Also

```Swift
container.register(AnimalType.self) { _, name in Horse(name: name) }
let horse1 = container.resolve(AnimalType.self, argument: "Spirit")
```

becomes

```Swift
container.registerAnimalType { (_, name:String) in
  Horse(name: name)
}
let horse1 = container.resolveAnimalType("Spirit")
```

We can provide more examples if desired.

## Integration

The Integration is currently done by calling the following code in a very early (i.e. before compilation) build phase:
```SH
cd ${SRCROOT}/CodeGeneration/
swinject_codegen -i baseInput.csv -o extensions/baseContainerExtension.swift
swinject_codegen -i iosInput.csv -o extensions/iosContainerExtension.swift
swinject_codegen -i tvosInput.csv -o extensions/tvosContainerExtension.swift
```

The resulting extension files are added to xcode and given appropriate target settings.

## Migration
The script also generates migration.sh files (when using the -m switch), which use sed to go through the code and replace simple cases (i.e. no arguments) of resolve and register.
No automatic migration is available for cases with arguments, yet.
Simply call the .sh file from the root of the project and compare the results in a git-GUI.

## Results
We currently use the code generation in a medium-sized app, with a total of ~130 lines of definitions across 3 .csv files (shared definitions, iOS only, tvOS only).
We found our code to become much more convenient to read and write, due to reduced duplication and autocompletion. We also have a much better overview the classes available through dependency injection.
Changing some definition immediately leads to information, where an error will occur.
We were able to replace all our occurences of `.resolve(` and `.register(` using the current implementation.


## Contributors
The main contributors for this are [Daniel Dengler](https://github.com/ddengler), [David Kraus](https://github.com/davidkraus) and [Wolfgang Lutz](https://github.com/lutzifer).
