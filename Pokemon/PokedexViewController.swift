//
//  PokedexViewController.swift
//  Pokemon
//
//  Created by Enrique V. Kortright on 5/6/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var pokemons : [Pokemon] = []
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemons = getAllPokemon()
        for pokemon in pokemons {
            if pokemon.caught {
                caughtPokemons.append(pokemon)
            } else {
                uncaughtPokemons.append(pokemon)
            }
        }
        print("caught: \(caughtPokemons)")
        print("uncaught: \(uncaughtPokemons)")
        
        tableView.dataSource = self
        tableView.delegate = self

    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemons.count
        } else {
            return uncaughtPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pokemon : Pokemon? = nil
        if indexPath.section == 0 {
            pokemon = caughtPokemons[indexPath.row]
        } else {
            pokemon = uncaughtPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon?.name
        cell.imageView?.image = UIImage(named: pokemon!.imageName!)
        return cell
    }
}
