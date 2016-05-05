class Dog: AnimalType {
    var name: String?

    init(name: String?) {
        self.name = name
    }

    func sound() -> String {
        return "Bow wow!"
    }
}