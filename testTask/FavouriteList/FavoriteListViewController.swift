//
//  FavoriteListViewController.swift
//  testTask
//
//  Created by SashaShch on 17.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {
    var viewModel: FavouriteListViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        viewModel = FavouriteListViewModel()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadBreeds()
    }
}

extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavouriteTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "favourite cell", for: indexPath) as! FavouriteTableViewCell
        
        cell.favouriteLabel.text = viewModel.getBreedDescription(index: indexPath.item)
        
        return cell
    }
}

extension FavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "FavouritePhotoViewController") as! FavouritePhotoViewController
            vc.viewModel = FavouritePhotoViewModel(breed: viewModel.breeds[indexPath.item])
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FavoriteListViewController: FavoriteListViewModelDelegate {
    func didStartLoadingBreeds() {
        
    }
    
    func didFinishLoadingBreeds() {
        self.tableView.reloadData()
    }
}
