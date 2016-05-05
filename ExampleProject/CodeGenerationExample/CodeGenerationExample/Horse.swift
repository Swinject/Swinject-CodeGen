class Horse: AnimalType {
    var name: String?
    var running: Bool

    convenience init(name: String) {
        self.init(name: name, running: false)
    }

    init(name: String, running: Bool) {
        self.name = name
        self.running = running
    }

    func sound() -> String {
        return "Whinny!"
    }
}