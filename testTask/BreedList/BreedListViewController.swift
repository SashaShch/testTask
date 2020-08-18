//
//  BreedListViewController.swift
//  testTask
//
//  Created by SashaShch on 15.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class BreedListViewController: UIViewController {
    var viewModel: BreedListViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Breeds"
        viewModel = BreedListViewModel()
        viewModel.delegate = self
        
        viewModel.fetchBreeds()
    }
}


extension BreedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breedsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BreedTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "info cell", for: indexPath) as! BreedTableViewCell
        
        cell.breedLabel.text = viewModel.breedsList[indexPath.item].breedDescription
        return cell
    }
}

extension BreedListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.breedsList[indexPath.item].subBreed.isEmpty == false {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SubBreedListViewController") as! SubBreedListViewController
            vc.breedInfo = viewModel.breedsList[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhotosListViewController") as! PhotosListViewController
            vc.viewModel = PhotosListViewModel(breed: viewModel.breedsList[indexPath.item].breed, subBreed: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension BreedListViewController: BreedListViewModelDelegate {
    func didStartFetchingBreeds() {
        
    }
    
    func didFinishFetcingBreeds() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

