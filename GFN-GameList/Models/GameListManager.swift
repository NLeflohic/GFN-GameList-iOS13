//
//  GameListManager.swift
//  GFN-GameList
//
//  Created by nicolas le flohic on 11/02/2020.
//  Copyright © 2020 nicolas le flohic. All rights reserved.
//

import Foundation

protocol GameListDelegate {
    func didUpdateFinished (for data: [GameRealm])
}

struct GameListManager {
    var delegate : GameListDelegate?
    
    func fetchData() {
        if let uslString = URL (string: K.urlNvidia) {
            if let safeData = try? Data(contentsOf: uslString) {
                self.parseJSON (data: safeData)
            }
        }
    }
    
    func parseJSON (data : Data) {
        let decoder = JSONDecoder ()
        do {
        let gamesList = try decoder.decode([GameRealm].self, from: data)
            delegate?.didUpdateFinished (for: gamesList)
        } catch {
            print (error.localizedDescription)
        }
    }
}

