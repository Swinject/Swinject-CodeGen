public class InjectablePerson: PersonType {
    var pet: AnimalType? {
        didSet {
            log = "Injected by property."
        }
    }
    var log = ""

    init() { }

    init(pet: AnimalType) {
        self.pet = pet
        log = "Injected by initializer."
    }

    func setPet(_ pet: AnimalType) {
        self.pet = pet
        log = "Injected by method."
    }

    public func play() -> String {
        return log
    }
}
