//
//  ViewController.swift
//  Pokemon
//
//  Created by Enrique V. Kortright on 5/5/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount : Int = 0
    
    var manager = CLLocationManager()
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setupGame()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setupGame()
        }
    }
    
    func setupGame() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            print("timer")
            if let coord = self.manager.location?.coordinate {
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let annotation = PokemonAnnotation(coord: coord, pokemon: pokemon)
                let randomLatitude = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randomLongitude = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annotation.coordinate.latitude += randomLatitude
                annotation.coordinate.longitude += randomLongitude
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations: \(locations)")
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: true)
            mapView.showsPointsOfInterest = true
            mapView.showsBuildings = true
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "player-1")
            var frame = annotationView.frame
            frame.size.height = 50
            frame.size.width = 50
            annotationView.frame = frame
            return annotationView
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemonAnnotation = annotation as! PokemonAnnotation
        annotationView.image = UIImage(named: pokemonAnnotation.pokemon.imageName!)
        var frame = annotationView.frame
        frame.size.height = 50
        frame.size.width = 50
        annotationView.frame = frame
        return annotationView
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
            mapView.showsPointsOfInterest = true
            mapView.showsBuildings = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("mapView.didSelect \(view)")
        mapView.deselectAnnotation(view.annotation!, animated: true)
        if view.annotation is MKUserLocation { return }
        print("pokemon annotation tapped")
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: false)
        
        if let coord = manager.location?.coordinate {
            let pokemon = (view.annotation! as! PokemonAnnotation).pokemon
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                print("catchable")
                if !pokemon.caught {
                    pokemon.caught = true
                    delegate.saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(pokemon.name!). You are a Pokemon Master!", preferredStyle: .alert)
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAction)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okAction)
                    present(alertVC, animated: true, completion: nil)
                } else {
                    pokemon.caught = false
                    delegate.saveContext()
                }
            } else {
                print("uncatchable")
                let alertVC = UIAlertController(title: "Uh-Oh", message: "You are too far away to catch the \(pokemon.name!). Move closer to it!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(okAction)
                present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
}

