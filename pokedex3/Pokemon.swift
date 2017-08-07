//
//  Pokemon.swift
//  pokedex3
//
//  Created by Tolik Ivanov on 18/04/2017.
//  Copyright © 2017 Tolik Ivanov. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name: String!
    private var _pokedexid: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
    //MARK: - Getters and Setters and Init()
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
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
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
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
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
         return _nextEvolutionTxt
    }
    
    
    var name: String {
        return _name
    }
    
    var pokedexid: Int {
        
        return _pokedexid
    }
    
    init(name: String, pokedexid: Int) {
        
        self._name = name
        self._pokedexid = pokedexid
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexid)/"
        
    }
    
    //MARK: - Download Pokemon Details
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? [String:Any] {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
            if let height = dict["height"] as? String {
                self._height = height
            }
            if let attack = dict["attack"] as? Int {
                self._attack = "\(attack)"
            }
            if let defense = dict["defense"] as? Int {
                self._defense = "\(defense)"
            }
            
            print(self._weight)
            print(self._height)
            print(self._attack)
            print(self._defense)
            
                // a call for types from the api
                /*
                Since the type is a dictionary of array of dictionaries
                 
                */
                // if there's atleast one name this block will called
            if let types = dict["types"] as? [[String:String]] , types.count > 0 {
                if let name = types[0]["name"] {
                    self._type = name.capitalized
                }
                // this block will called when we have more than 1 type
                if types.count > 1 {
                    
                    // we will go inside the loop and iterate trough the types.count
                    // adding name to the type
                    for x in 1..<types.count {
                        if let name = types[x]["name"] {
                            // adding new type to previous one
                            self._type! += "/\(name.capitalized)" // the tpe name will populate our UI
                        }
                    }
                }
                // check print
                print(self._type)
                //this case called when no type returnted from the api
            } else {
                self._type = "" // no type returned - empty string will populate the UI
                }
               
                // call from the api fro descriptions 
                // this block will called when there's atleast one description returned
                if let descriptionArr = dict["descriptions"] as? [[String:String]] , descriptionArr.count > 0 {
                    
                    if let url = descriptionArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? [String:Any] {
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            
                            completed()
                        })
                    }
                } else {
                    // this case called when no descripiton returned from the api
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [[String:Any]] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil{
                            
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int{
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                } else {
                                self._nextEvolutionLevel = ""
                               }
                            }
                        }
                    }
                    print(self.nextEvolutionLevel)
                    print(self.nextEvolutionId)
                    print(self.nextEvolutionText)
                    print(self.nextEvolutionName)
                }
             }
            
            completed()
        }
    }
    
    
}
