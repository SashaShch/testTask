//
//  FavouritePhotoViewModel.swift
//  testTask
//
//  Created by SashaShch on 18.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import Foundation

protocol FavouritePhotoViewModelDelegate {
    func didStartLoadingPhotos()
    func didFinishLoadingPhotos()
}

class FavouritePhotoViewModel {
    var delegate: FavouritePhotoViewModelDelegate?
    let defaults = UserDefaults.standard
    
    var breed: String
    var photos = [String]()
    
    init(breed: String) {
        self.breed = breed
    }
    
    func loadPhotos() {
        delegate?.didStartLoadingPhotos()
        
        DispatchQueue.main.async {
            self.photos = self.defaults.value(forKey: self.breed) as! [String]
            self.delegate?.didFinishLoadingPhotos()
        }
    }
}
