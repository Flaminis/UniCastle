//
//  AppService.swift
//  DotaMate
//
//  Created by Philip DesJean on 9/5/16.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit

class AppService: NSObject {
    
    static let shared = AppService()
    
//    let api = DotaMateApi()
//    
//    var items = [Int:DMItems]()
//    
//    var heroes = [Int:DMHeroes]()
//    
//    var currentAccount : Profile?
    
    //<<<<<<< Updated upstream
    var universityID = String()
    var username = String()
    var password = String()
    var searchModuleName = String()
    var searchCourseName = String()

    
    func setup() {
//        api.getItems()
//        api.downloadHeroesFromAPI()
    }
    
    func setAccountFor(moduleList: [String]) {
    }
    
}
