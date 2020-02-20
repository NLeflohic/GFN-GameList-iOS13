//
//  GameRealm.swift
//  GFN-GameList
//
//  Created by nicolas le flohic on 11/02/2020.
//  Copyright © 2020 nicolas le flohic. All rights reserved.
//

import Foundation
import RealmSwift

class GameRealm: Object, Codable {
    @objc dynamic var id : Int = 0
    @objc dynamic var title : String = ""
    @objc dynamic var isFullyOptimized : Bool = false
    @objc dynamic var isHighlightsSupported : Bool = false
    @objc dynamic var steamUrl : String? = ""
    //@objc dynamic var publisher : String = ""
    //let genres = List<String>()
    //@objc dynamic var status : String = ""
}

