//
//  GamesViewController.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/6/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit
import Firebase

class GamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bannerAd = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var gamesTableView: UITableView!
    var month: Month! {
        didSet {
            navigationItem.title = month.name
            fetchGames()
        }
    }
    var games = [Game]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        loadBannerAd()
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "message"), style: .plain, target: self, action: #selector(showCommentsController))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GamesTableViewCell else {
            fatalError("The dequed cell is not an instance of GameTableViewCell")
        }
        
        let game = games[indexPath.row]
        
        cell.configureCell(game: game)
        
        return cell
    }
    
    func fetchGames() {
        Database.database().reference().child("games/\(month.id)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let video = value?["video"] as? String ?? ""
            if let games = value?["games"] as? [String: AnyObject] {
                self.setupView(video: video, games: games)
            }
            
        })
    }
    
    func setupView(video: String, games: [String: AnyObject]) {
        let videoUrl = URL(string: "https://www.youtube.com/embed/\(video)")
        self.videoWebView.loadRequest(URLRequest(url: videoUrl!))
        for object in games {
            let value = object.value as! NSDictionary
            let game = Game(object: value)
            self.games.append(game)
        }
        self.gamesTableView.reloadData()
        
        
    }
    
    func showCommentsController() {
        let commentLogController = CommentsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentLogController.month = month
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.pushViewController(commentLogController, animated: true)
    }
    
    //MARK: Ad Methods
    
    func loadBannerAd() {
        bannerAd?.adUnitID = "ca-app-pub-8452783658374563/5380329135"
        bannerAd?.rootViewController = self
        bannerAd?.load(GADRequest())
    }
}

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
        return newSize
    }
}

