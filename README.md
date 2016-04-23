# Swinject Code Generation

I would call it a very elaborated proof of concept, though we use it in production atm.
We are open for every kind of feedback, improvements of the generated code/templates, discussion of the input format etc.

## TLDR;

We propose a method to get rid of duplicate use of class values and namestrings, by generating explicit functions for registering and resolving.
Doing this, we also can generate typed tuples to use when resolving, thus allowing better documented and less error-prone code.

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
We have implemented a first version, that uses a .csv file to define the generated calls, though we are considering switching to .yml for better readability.
It would also be an option to allow both formats.

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

Our yet-to-specificy yml format could follow the following structure:

```yml
dependencies:
 - KeychainAccess
definitions:
 - sourceClass: SourceClass
   targetClass: TargetClass
   identifier: Identifier
   arguments:
      - argumentName1:ArgumentType
      - ArgumentTypeWithoutSpecificName
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
ruby build.rb baseInput.csv extensions/baseContainerExtension.swift
ruby build.rb iosInput.csv extensions/iosContainerExtension.swift
ruby build.rb tvosInput.csv extensions/tvosContainerExtension.swift
```

The resulting extension files are added to xcode and given appropriate target settings.

## Migration
The script also generates migration.sh files, which use sed to go through the code and replace simple cases (i.e. no arguments) of resolve and register.
No automatic migration is available for cases with arguments, yet.
Simply call the .sh file from the root of the project and compare the results in a git-GUI.

## Results
We currently use the code generation in a medium-sized app, with a total of ~130 lines of definitions across 3 .csv files (shared definitions, iOS only, tvOS only).
We found our code to become much more convenient to read and write, due to reduced duplication and autocompletion. We also have a much better overview the classes available through dependency injection.
Changing some definition immediately leads to information, where an error will occur.
We were able to replace all our occurences of `.resolve(` and `.register(` using the current implementation.

## Distribution
We aim to distribute this using cocoapods and carthage in the near future.

## Contributors
The main contributors for this are [Daniel Dengler](https://github.com/ddengler), [David Kraus](https://github.com/davidkraus) and [Wolfgang Lutz](https://github.com/lutzifer).
