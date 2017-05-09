//
//  CoreDateHelp.swift
//  Pokemon
//
//  Created by Enrique V. Kortright on 5/6/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit
import CoreData

let delegate = UIApplication.shared.delegate as! AppDelegate
let context = delegate.persistentContainer.viewContext

func addAllPokemon() {
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Mankey", imageName: "mankey")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Rattata", imageName: "rattata")
    createPokemon(name: "Eevee", imageName: "eevee")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Weedle", imageName: "weedle")
    createPokemon(name: "Zubat", imageName: "zubat")
    delegate.saveContext()
}

func createPokemon(name: String, imageName: String) {
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}

func getAllPokemon() -> [Pokemon] {
    var pokemons : [Pokemon] = []
    
    do {
        try pokemons = context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        print("number of pokemon: \(pokemons.count)")
        if pokemons.count == 0 {
            addAllPokemon()
            try pokemons = context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        }
    } catch {
        print("Error getting all pokemon.")
    }
    
    return pokemons
}
