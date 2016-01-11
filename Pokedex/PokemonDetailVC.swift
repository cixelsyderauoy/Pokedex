//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Zachary Ryan on 1/9/16.
//  Copyright © 2016 Zachary Ryan. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameAndNumbLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var abilitiesLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var hpLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var spAtkLbl: UILabel!
    @IBOutlet weak var spDefLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!

    
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameAndNumbLbl.text = "\(pokemon.name.capitalizedString) #\(pokemon.pokedexId)"
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            //this will be called after download is done
            self.updateUI()
        }

    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        abilitiesLbl.text = pokemon.abilities
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        hpLbl.text = "\(pokemon.hp)"
        speedLbl.text = "\(pokemon.speed)"
        attackLbl.text = "\(pokemon.attack)"
        defenseLbl.text = "\(pokemon.defense)"
        spAtkLbl.text = "\(pokemon.spAtk)"
        spDefLbl.text = "\(pokemon.spDef)"
        
        if pokemon.nextEvolutionId == "" {
            //Need to update text
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
