public class Cat: AnimalType {
    public var name: String?

    init(name: String?) {
        self.name = name
    }

    public func sound() -> String {
        return "Meow!"
    }
}
