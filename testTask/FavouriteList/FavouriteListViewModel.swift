//
//  FavouriteListViewModel.swift
//  testTask
//
//  Created by SashaShch on 18.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import Foundation

protocol FavoriteListViewModelDelegate {
    func didStartLoadingBreeds()
    func didFinishLoadingBreeds()
}


class FavouriteListViewModel {
    var delegate: FavoriteListViewModelDelegate?
    
    var favouritesBreeds = [String:[String]]()
    var breeds = [String]()
    
    func loadBreeds() {
        delegate?.didStartLoadingBreeds()
        DispatchQueue.main.async {
            self.favouritesBreeds = UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier ?? "") as! [String:[String]]
            
            let keysToRemove = self.favouritesBreeds.keys.filter { self.favouritesBreeds[$0]!.isEmpty == true}
            
            for key in keysToRemove {
                self.favouritesBreeds.removeValue(forKey: key)
            }
            
            for (keys, _) in self.favouritesBreeds {
                if !self.breeds.contains(keys) {
                    self.breeds.append(keys)
                }
            }
            self.delegate?.didFinishLoadingBreeds()
        }
    }
    
    func getBreedDescription(index: Int) -> String {
        let photoCount = favouritesBreeds[breeds[index]]?.count
        return "\(breeds[index])(\(photoCount ?? 0))"
    }
}
