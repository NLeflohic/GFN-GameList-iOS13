//
//  GameDetailController.swift
//  GFN-GameList
//
//  Created by nicolas le flohic on 11/02/2020.
//  Copyright © 2020 nicolas le flohic. All rights reserved.
//


import UIKit
import RealmSwift

class GameDetailController: UITableViewController {
    var ofLetter : String?
    var currentDetailGameList : Results<GameRealm>?
    {
        didSet {
            loadData ()
        }
    }
    
    var currentGamesList : GameList?
    var rootController = InitialViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 55;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDetailGameList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.gameCellIdentifier, for: indexPath) as! TableViewCell
//        cell.textLabel?.text = currentDetailGameList?[indexPath.row].title ?? ""
        cell.title.text = currentDetailGameList?[indexPath.row].title ?? ""
        var optimizedStr = ""
        var colorCode = 0
        if let optimized = currentDetailGameList?[indexPath.row].isFullyOptimized {
            optimizedStr = getStringFromBool(boolValue: optimized)
            optimizedStr = optimized ? "\(K.optimized) Yes" : "\(K.optimized) No"
            if optimized {
                colorCode += 1
            }
        }
        var highLightsStr = ""
        if let highLights = currentDetailGameList?[indexPath.row].isHighlightsSupported {
            highLightsStr = getStringFromBool(boolValue: highLights)
            highLightsStr = highLights ? "\(K.supported) Yes" : "\(K.supported) No"
            if highLights {
                colorCode += 1
            }
        }
        
        //cell.detailTextLabel?.text = "\(optimizedStr) \n \(highLightsStr)"
        //cell.detailTextLabel?.numberOfLines = 0
        cell.subtitle.text = "\(optimizedStr)          \(highLightsStr)"
        cell.subtitle.numberOfLines = 0
        if colorCode == 2 {
//            cell.backgroundColor = UIColor(red:0.00, green:0.72, blue:0.58, alpha:1.0)
            cell.imageDot.backgroundColor = UIColor(red:0.00, green:0.72, blue:0.58, alpha:1.0)
        }
        else if colorCode == 0 {
            //cell.backgroundColor = UIColor(red:0.84, green:0.19, blue:0.19, alpha:1.0)
            cell.imageDot.backgroundColor = UIColor(red:0.84, green:0.19, blue:0.19, alpha:1.0)
        } else {
            //cell.backgroundColor = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0)
            cell.imageDot.backgroundColor = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0)
        }
//        cell.imageDot.layer.bounds.insetBy(dx: 20, dy: 20)
//        cell.imageDot.frame.width = CGFloat(15)
        cell.imageDot.layer.cornerRadius = cell.imageDot.frame.height / 2
        cell.imageDot.layer.masksToBounds = true;
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let indexPath = tableView.indexPathForSelectedRow {
            if let destUrl = currentDetailGameList?[indexPath.row].steamUrl {
                if destUrl == "" {
                    let alert = UIAlertController(title: "Warning", message: "No url specified !", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if let destUrl = currentDetailGameList?[indexPath.row].steamUrl {
                if segue.identifier == "goToWebView" {
                    let destinationVC = segue.destination as! WebViewController
                    destinationVC.urlToGo = destUrl
                }
            }
        }
    }
//        if segue.identifier == "goToWebView" {
//            let destinationVC = segue.destination as! WebViewController
//            if let indexPath = tableView.indexPathForSelectedRow {
//                if let destUrl = currentDetailGameList?[indexPath.row].steamUrl {
//                    if destUrl != "" {
//                        destinationVC.urlToGo = destUrl
//                    } else {
//                        print ("url vide")
//                        dismiss(animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//    }
    
    func loadData () {
        tableView.reloadData()
    }
    
    func getStringFromBool (boolValue: Bool) -> String {
        return  boolValue ? "Yes" : "No"
    }
    
    
}

