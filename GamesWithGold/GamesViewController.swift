//
//  GamesViewController.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/6/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class GamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bannerAd: GADBannerView!
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var gamesTableView: UITableView!
    var id = ""
    var games = [Game]()
    var interstital: GADInterstitial!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        
        fetchGames()
        
        loadBannerAd()
        interstital = loadInterstitial()
        NotificationCenter.default.addObserver(self, selector: #selector(self.runInterstitial), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        FIRDatabase.database().reference().child("games/\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
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
            let value = object.value
            let name = value["name"] as? String
            let img = value["img"] as? String
            let range = value["range"] as? String
            let platform = value["platform"] as? String
            let game = Game(name: name, platform: platform, range: range, img: img)
            self.games.append(game)
        }
        self.gamesTableView.reloadData()
        
        
    }
    
    //MARK: Ad Methods
    
    func loadBannerAd() {
        bannerAd.adUnitID = "ca-app-pub-8452783658374563/5380329135"
        bannerAd.rootViewController = self
        bannerAd.load(GADRequest())
    }
    
    func loadInterstitial() -> GADInterstitial {
        let interstital = GADInterstitial(adUnitID: "ca-app-pub-8452783658374563/3052644738")
        let request = GADRequest()
        interstital.load(request)
        return interstital
    }
    
    func runInterstitial() {
        if (interstital.isReady) {
            interstital.present(fromRootViewController: self)
            interstital = loadInterstitial()
        }
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
