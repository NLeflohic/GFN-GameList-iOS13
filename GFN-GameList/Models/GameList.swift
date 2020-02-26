//
//  GameList.swift
//  GFN-GameList
//
//  Created by nicolas le flohic on 11/02/2020.
//  Copyright © 2020 nicolas le flohic. All rights reserved.
//

import Foundation

struct GameList : Codable {
    var list : [GameRealm]
    
    func GetDetailList (of forLetter: String) -> [GameRealm] {
        var detailGamesList = [GameRealm]()
        for i in 0 ..< list.count {
            if let char = list[i].title.first {
                if String (char) == forLetter {
                    detailGamesList.append(list[i])
                }
            }
        }
        return detailGamesList
    }
}

struct Games : Codable {
    var id : Int
    var title : String
    var isFullyOptimized : Bool
    var isHighlightsSupported : Bool
    var steamUrl : String?
    var publisher : String
    var genres : [String]
    var status : String
}

struct Folder {
    var list = [GamesFolders]()
    
    mutating func addGame (game: GameRealm) {
        if let char = game.title.capitalized.first{
            for i in 0..<list.count {
                if let capLetter = list[i].letter {
                    if String(capLetter).capitalized == String(char) {
                        list[i].add ()
                        return
                    }
                }
            }
        let newGame = GamesFolders(letter: char, number: 1)
        list.append(newGame)
        list = ascSortList()
        }
    }
    
    mutating func reinitList() {
        list = []
    }
    
    func ascSortList () -> [GamesFolders]{
        return list.sorted(by: {
            if let char1 = $0.letter {
                if let char2 = $1.letter {
                    //return $0.letter.hashValue > $1.letter.hashValue
                    return char1 < char2
                }
            }
            return false
        }
        )
    }
}

struct GamesFolders {
    var letter : Character?
    var number : Int
    
    var numberOfGames : String {
        if number > 1 {
        return String(number) + " " + K.labelGames
        } else {
            return String(number) + " " + K.labelGame
        }
    }
    
    mutating func add () {
        self.number = self.number + 1
    }
}
