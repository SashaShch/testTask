//
//  BreedListViewModel.swift
//  testTask
//
//  Created by SashaShch on 18.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import Foundation

protocol BreedListViewModelDelegate {
    func didStartFetchingBreeds()
    func didFinishFetcingBreeds()
}

class BreedListViewModel {
    var delegate: BreedListViewModelDelegate?
    var breedsList = [Breed]()
    
    func fetchBreeds() {
        delegate?.didStartFetchingBreeds()
        if let url = URL(string: "https://dog.ceo/api/breeds/list/all") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let response = jsonObj as? [String: Any] {
                            if let list = response["message"] as? [String: [String]] {
                                for item in list {
                                    self.breedsList.append(Breed(breed: item.key, subBreed: item.value))
                                }
                            }
                            self.delegate?.didFinishFetcingBreeds()
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
