//
//  Pokemon.swift
//  Pokedex
//
//  Created by Zachary Ryan on 1/9/16.
//  Copyright © 2016 Zachary Ryan. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _abilities: String!
    private var _height: String!
    private var _weight: String!
    private var _hp: Int!
    private var _speed: Int!
    private var _attack: Int!
    private var _defense: Int!
    private var _spAtk: Int!
    private var _spDef: Int!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var abilities: String {
        if _abilities == nil {
            _abilities = ""
        }
        return _abilities
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var hp: Int {
        if _hp == nil {
            _hp = -1
        }
        return _hp
    }
    
    var speed: Int {
        if _speed == nil {
            _speed = -1
        }
        return _speed
    }
    
    var attack: Int {
        if _attack == nil {
            _attack = -1
        }
        return _attack
    }
    
    var defense: Int {
        if _defense == nil {
            _defense = -1
        }
        return _defense
    }
    
    var spAtk: Int {
        if _spAtk == nil {
            _spAtk = -1
        }
        return _spAtk
    }
    
    var spDef: Int {
        if _spDef == nil {
            _spDef = -1
        }
        return _spDef
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
        
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            

            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    self._description = description
                                    print(self._description)

                                }
                            }
                            
                            completed()
                        }
                        
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type.capitalizedString
                    }
                
                    if types.count > 1 {
                        
                        for var x = 1; x < types.count; x++ {
                            if let type = types[x]["name"] {
                                self._type! += " / \(type.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let abilities = dict["abilities"] as? [Dictionary<String, String>] {
                    if let ability = abilities[0]["name"] {
                        self._abilities = ability.capitalizedString
                    }
                    
                    if abilities.count > 1 {
                        for var x = 1; x < abilities.count; x++ {
                            if let ability = abilities[x]["name"] {
                                self._abilities! += " and \(ability.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._abilities = ""
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let hp = dict["hp"] as? Int {
                    self._hp = hp
                }
                
                if let speed = dict["speed"] as? Int? {
                    self._speed = speed
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = attack
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                }
                
                if let spAtk = dict["sp_atk"] as? Int {
                    self._spAtk = spAtk
                }
                
                if let spDef = dict["sp_def"] as? Int {
                    self._spDef = spDef
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0{
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Can't support mega pokemon right now but
                        //api still has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
//                            print(self._nextEvolutionId)
//                            print(self._nextEvolutionTxt)
//                            print(self._nextEvolutionLvl)
//                                
                            }
                        }
                        
                    }
                    
                }
                
//                print(self._description)
//                print(self._type)
//                print(self._abilities)
//                print(self._weight)
//                print(self._height)
//                print(self._hp)
//                print(self._speed)
//                print(self._attack)
//                print(self._defense)
//                print(self._spAtk)
//                print(self._spDef)
                
            }
        }
        
    }
    
}