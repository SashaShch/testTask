//
//  Breed.swift
//  testTask
//
//  Created by SashaShch on 15.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import Foundation

struct Breed {
    var breed: String
    var subBreed: [String]


    func hasSubBreed() -> Bool {
        return subBreed.isEmpty == true ? false :  true
    }
    
}
