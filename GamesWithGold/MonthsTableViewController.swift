//
//  MonthsTableViewController.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/6/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit
import Firebase

class MonthsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: Properties
    @IBOutlet weak var monthsTableView: UITableView!
    @IBOutlet weak var bannerAd = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
    var sections = Dictionary<String, Array<Month>>()
    var sortedSections = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthsTableView.delegate = self
        monthsTableView.dataSource = self
        navigationSetup()
        
        if (Auth.auth().currentUser) != nil {
            
            fetchMonths()
        } else {
            
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.fetchMonths()
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadBannerAd()
        
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[sortedSections[section]]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTableViewCell", for: indexPath) as? MonthTableViewCell else {
            fatalError("The dequed cell is not an instance of MonthTableViewCell")
        }
        
        let tableSection = sections[sortedSections[indexPath.section]]
        let tableItem = tableSection![indexPath.row]
        
        cell.nameLabel.text = tableItem.name

        // Configure the cell...
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section]
    }
    
    // MARK: Ad Methods
    
    func loadBannerAd() {
        bannerAd?.adUnitID = "ca-app-pub-8452783658374563/4651972339"
        bannerAd?.rootViewController = self
        bannerAd?.load(GADRequest())
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? GamesViewController {
           let section = sections[sortedSections[(monthsTableView.indexPathForSelectedRow?.section)!]]
           let tableItem = section![(monthsTableView.indexPathForSelectedRow?.row)!]
           destination.month = tableItem
        }
    }
    
    // MARK: Private Methods
    
    func navigationSetup() {
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        let logo = UIImage(named: "header.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    private func fetchMonths() {
        Database.database().reference().child("months").observe(.childAdded, with: { (snapshot) -> Void in
            let id: String = snapshot.key
            let year = id.components(separatedBy: "m")[0]
            let name = snapshot.value as! String
            
            // If we dont have a section "year" for a particular date we create one, otherwise just add it to an existing one.
            if self.sections.index(forKey: year) == nil {
                self.sections[year] = [Month(name: name, id: id)]
            } else {
                self.sections[year]!.insert(Month(name: name, id: id), at: 0)
            }
            
            // Sort Sections in dictionary
            self.sortedSections = self.sections.keys.sorted(by: >)
            
            DispatchQueue.main.async {
                self.monthsTableView.reloadData()
            }
        })
    }

}


