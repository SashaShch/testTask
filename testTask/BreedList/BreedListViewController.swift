//
//  BreedListViewController.swift
//  testTask
//
//  Created by SashaShch on 15.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class BreedListViewController: UIViewController {
    
    var dogInfo = Dog(dogInfo: [])
    
    @IBOutlet weak var tableView: UITableView!
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Breeds"
        
        let urlStr = "https://dog.ceo/api/breeds/list/all"

        if let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let response = jsonObj as? [String: Any] {
                            if let list = response["message"] as? [String: [String]] {
                                for item in list {
                                    DispatchQueue.main.async {
                                        self.dogInfo.dogInfo.append(Breed(breed: item.key, subBreed: item.value) )
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
}


extension BreedListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogInfo.dogInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BreedTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "info cell", for: indexPath) as! BreedTableViewCell
        
        
        
        cell.breedLabel.text = "\(dogInfo.dogInfo[indexPath.item].breed)(\(dogInfo.dogInfo[indexPath.item].subBreed.count))"
        return cell
    }
}
extension BreedListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dogInfo.dogInfo[indexPath.item].subBreed.isEmpty == false {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SubBreedListViewController") as! SubBreedListViewController
            vc.breedInfo = self.dogInfo.dogInfo[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "BreedPhotoViewController") as! BreedPhotoViewController
            vc.breedInfo = self.dogInfo.dogInfo[indexPath.item].breed
            vc.breedTitle = self.dogInfo.dogInfo[indexPath.item].breed
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

