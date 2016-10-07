//
//  AppDelegate.swift
//  CodeGenerationExample
//
//  Created by Wolfgang Lutz on 05.05.16.
//  Copyright © 2016 swinject. All rights reserved.
//

import UIKit
import Swinject

let appModule = Container() {
    container in

    // container.register(AnimalType.self) { _ in Cat(name: "Mimi") }
    container.registerCat { _ in Cat(name: "Mimi") }

    // container.register(PersonType.self) { r in PetOwner(pet: r.resolve(AnimalType.self)!) }
    container.registerPersonType { r in PetOwner(pet: r.resolve(AnimalType.self)!) }

    // container.register(AnimalType.self, name: "dog") { _ in Dog(name: "Hachi") }
    container.registerAnimalType_dog { _ in Dog(name: "Hachi") }

    // container.register(PersonType.self, name: "doggy") { r in PetOwner(pet: r.resolve(AnimalType.self, name: "dog")!) }
    container.registerPersonType_doggy { r in PetOwner(pet: r.resolve(AnimalType.self, name: "dog")!) }

    // container.register(AnimalType.self, name: "cb") { _ in Cat(name: "Mew") }
    container.registerAnimalType_cb { _ in Cat(name: "Mew") }

    // container.register(PersonType.self, name: "initializer") { r in
    container.registerPersonType_initializer { r in
        InjectablePerson(pet: r.resolve(AnimalType.self)!)
    }

    // container.register(PersonType.self, name: "property1") { r in
    container.registerPersonType_property1 { r in
        let person = InjectablePerson()
        person.pet = r.resolve(AnimalType.self)
        return person
    }
    // container.register(PersonType.self, name: "property2") { _ in InjectablePerson() }
    container.registerPersonType_property2 { _ in InjectablePerson() }
        .initCompleted { r, p in
            let injectablePerson = p as! InjectablePerson
            injectablePerson.pet = r.resolve(AnimalType.self)
    }

    //  container.register(PersonType.self, name: "method1") { r in
    container.registerPersonType_method1 { r in
        let person = InjectablePerson()
        person.setPet(r.resolve(AnimalType.self)!)
        return person
    }

    // container.register(PersonType.self, name: "method2") { _ in InjectablePerson() }
    container.registerPersonType_method2 { _ in InjectablePerson() }
        .initCompleted { r, p in
            let injectablePerson = p as! InjectablePerson
            injectablePerson.setPet(r.resolve(AnimalType.self)!)
    }

    // container.register(AnimalType.self) { _, name in Horse(name: name) }
    container.registerHorse { _, name in Horse(name: name) }

    // container.register(AnimalType.self) { _, name, running in Horse(name: name, running: running) }
    container.registerHorse { _, name, running in Horse(name: name, running: running) }

    // container.register(AnimalType.self) { _ in Turtle(name: "Reo") }
    container.registerTurtle { _ in Turtle(name: "Reo") }
        .inObjectScope(.container)


}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // let person = appModule.resolve(PersonType.self)!
        let person = appModule.resolvePersonType()

        // let doggyPerson = appModule.resolve(PersonType.self, name:"doggy")!
        let doggyPerson = appModule.resolvePersonType_doggy()

        // let catWithCallback = appModule.resolve(AnimalType.self, name: "cb")
        let catWithCallback = appModule.resolveAnimalType_cb()

        // let initializerInjection = appModule.resolve(PersonType.self, name:"initializer")!
        let initializerInjection = appModule.resolvePersonType_initializer()

        // let propertyInjection1 = appModule.resolve(PersonType.self, name:"property1")!
        let propertyInjection1 = appModule.resolvePersonType_property1()

        // let propertyInjection2 = appModule.resolve(PersonType.self, name:"property2")!
        let propertyInjection2 = appModule.resolvePersonType_property2()

        // let methodInjection1 = appModule.resolve(PersonType.self, name:"method1")!
        let methodInjection1 = appModule.resolvePersonType_method1()

        // let methodInjection2 = appModule.resolve(PersonType.self, name:"method2")!
        let methodInjection2 = appModule.resolvePersonType_method2()

        //let horse1 = appModule.resolve(AnimalType.self, argument: "Spirit") as! Horse
        let horse1 = appModule.resolveHorse(name: "Spirit")

        // let horse2 = appModule.resolve(AnimalType.self, arguments: ("Lucky", true)) as! Horse
        let horse2 = appModule.resolveHorse(name: "Lucky", running: true)


        // let dog = appModule.resolve(AnimalType.self, name: "dog")
        let dog = appModule.resolveAnimalType_dog()

        // var turtle1 = appModule.resolve(AnimalType.self)!
        let turtle1 = appModule.resolveTurtle()

        print(person)
        print(doggyPerson)
        print(catWithCallback)
        print(initializerInjection)
        print(propertyInjection1)
        print(propertyInjection2)
        print(methodInjection1)
        print(methodInjection2)
        print(horse1)
        print(horse2)
        print(dog)
        print(turtle1)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

