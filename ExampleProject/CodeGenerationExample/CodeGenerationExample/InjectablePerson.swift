class InjectablePerson: PersonType {
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

    func setPet(pet: AnimalType) {
        self.pet = pet
        log = "Injected by method."
    }

    func play() -> String {
        return log
    }
}