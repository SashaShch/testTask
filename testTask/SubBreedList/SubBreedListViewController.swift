//
//  SubBreedListViewController.swift
//  testTask
//
//  Created by Рома on 16.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class SubBreedListViewController: UIViewController {
    
    var breedInfo = Breed(breed: "", subBreed: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = breedInfo.breed

    }

}

extension SubBreedListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedInfo.subBreed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubBreedTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "info subbreed cell", for: indexPath) as! SubBreedTableViewCell
        
        cell.subBreedLabel.text = breedInfo.subBreed[indexPath.item]
        return cell
    }
}
extension SubBreedListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "BreedPhotoViewController") as! BreedPhotoViewController
        vc.breedInfo = "\(self.breedInfo.breed)/\(self.breedInfo.subBreed[indexPath.item])"
        vc.breedTitle = "\(self.breedInfo.subBreed[indexPath.item])"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

