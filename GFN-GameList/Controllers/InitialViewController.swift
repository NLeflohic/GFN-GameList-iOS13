//
//  InitialViewController.swift
//  GFN-GameList
//
//  Created by nicolas le flohic on 11/02/2020.
//  Copyright © 2020 nicolas le flohic. All rights reserved.
//

import UIKit
import RealmSwift

class InitialViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var gameListManager = GameListManager()
    var gameList = GameList(list: [GameRealm]())
    var firstLetterGames = Folder()
    
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameListManager.delegate = self

        DispatchQueue.main.async {
            if self.isDatePassed(of: K.nbDaysBetweenSaves) {
                try! self.realm.write {
                    self.realm.deleteAll()
                self.gameListManager.fetchData()
                }
            } else {
                let results = self.realm.objects(GameRealm.self)
                if results.count == 0 {
                    self.gameListManager.fetchData()
                } else {
                    for result in results {
                        self.firstLetterGames.addGame (game : result)
                    }
                }
                self.updateNavBar (nbOfGames: results.count)
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstLetterGames.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = String(firstLetterGames.list[indexPath.row].letter!)
        cell.detailTextLabel?.text = firstLetterGames.list[indexPath.row].numberOfGames
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToGamesDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGamesDetail" {
            let gameDetailVC = segue.destination as! GameDetailController
            if let indexPath = tableView.indexPathForSelectedRow {
                if let letterStr = firstLetterGames.list[indexPath.row].letter{
                    gameDetailVC.ofLetter = String (letterStr)
                        gameDetailVC.currentDetailGameList = realm.objects(GameRealm.self).filter("title  BEGINSWITH '\(letterStr)'")
                }
            }
        }
    }
    
    func updateGameRealmData (gameRealm: GameRealm, fetchedGame: GameRealm) -> GameRealm{
        gameRealm.id = fetchedGame.id
        gameRealm.title = fetchedGame.title.capitalized
        gameRealm.isFullyOptimized = fetchedGame.isFullyOptimized
        gameRealm.isHighlightsSupported = fetchedGame.isHighlightsSupported
        gameRealm.steamUrl = fetchedGame.steamUrl
        return gameRealm
    }
    
}

extension InitialViewController: GameListDelegate {
    func didUpdateFinished(for data: [GameRealm]) {
        activityIndicator.startAnimating()
        self.gameList.list = data
        for game in gameList.list {
            firstLetterGames.addGame (game : game)
                let gameRealm = realm.objects(GameRealm.self).filter("id = \(game.id)").first
                try! realm.write {
                    if var gameRealmDb = gameRealm {
                       gameRealmDb = updateGameRealmData(gameRealm: gameRealmDb, fetchedGame: game)
                    } else {
                        var newGameRealm = GameRealm ()
                        newGameRealm = updateGameRealmData(gameRealm: newGameRealm, fetchedGame: game)
                        realm.add(newGameRealm)
                    }
                }
        }
        activityIndicator.stopAnimating()
        
        defaults.set(getDate(), forKey: "GFN_LastSave")
        updateNavBar (nbOfGames: gameList.list.count)
    }
    
    func updateNavBar (nbOfGames: Int) {
        let nbGamesStr = String(nbOfGames)
        navigationItem.title = "\(navigationItem.title ?? K.appTitle)  (\(nbGamesStr) Games)"
    }
    
    func getDate () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = K.formatDate
        return formatter.string(from: Date())
    }
    
    func isDatePassed (of nbOfDays: Int) -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = K.formatDate
        let currentDate = Date()
        let lastSaveDate = defaults.string(forKey: "GFN_LastSave")
        guard let newDate = Calendar.current.date(byAdding: .day, value: nbOfDays, to:formatter.date(from: lastSaveDate!)!) else {
            fatalError("Error while calculating date")
        }
        return currentDate > newDate
    }
}
