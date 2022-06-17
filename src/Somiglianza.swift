//
//  CellUserUserMatrix.swift
//  FindMyMovie
//
//  Created by Marco Di Lullo on 10/11/2019.
//  Copyright © 2019 Clemente Piscitelli. All rights reserved.
//

import Foundation

class Somiglianza{
    
    var usernameOtherUser: String
    var similarity: Float
    
    init(us: String, sim: Float) {
        self.usernameOtherUser = us
        self.similarity = sim
    }
}
