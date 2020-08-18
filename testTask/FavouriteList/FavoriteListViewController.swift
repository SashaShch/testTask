//
//  FavoriteListViewController.swift
//  testTask
//
//  Created by Рома on 17.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {
    
    var favouritesBreeds = [String:[String]]()
    var breeds = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var values = UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier ?? "") as! [String:[String]]
        favouritesBreeds = values
        let keysToRemove = values.keys.filter { values[$0]!.isEmpty == true}
        
        for key in keysToRemove {
            values.removeValue(forKey: key)
        }
        
        
        for (keys, _) in values {
            if !breeds.contains(keys) {
                breeds.append(keys)
            }
        }
        tableView.reloadData()
    }

}

extension FavoriteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavouriteTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "favourite cell", for: indexPath) as! FavouriteTableViewCell
        
        let photoCount = favouritesBreeds[breeds[indexPath.item]]?.count
        
        cell.favouriteLabel.text = "\(breeds[indexPath.item])(\(photoCount ?? 0))"
        
        return cell
    }
}
extension FavoriteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "FavouritePhotoViewController") as! FavouritePhotoViewController
            vc.breedInfo = self.breeds[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
