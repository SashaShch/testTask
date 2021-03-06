//
//  FavouritePhotoViewController.swift
//  testTask
//
//  Created by SashaShch on 17.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class FavouritePhotoViewController: UIPageViewController {
    
    var viewModel: FavouritePhotoViewModel!
    var pages = [UIViewController] ()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dataSource = self
        
        self.navigationItem.title = "Favourites"
        viewModel.delegate = self
        viewModel.loadPhotos()
    }
    
    func getViewController(urlStr: String) -> PhotoPageViewController
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhotoPageViewController") as! PhotoPageViewController
        if let url = URL(string: urlStr) {
            vc.imageURL = url
            vc.breedInfo = viewModel.breed
        }
        return vc
    }
}

extension FavouritePhotoViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard pages.count != 1 else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard pages.count != 1 else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
}

extension FavouritePhotoViewController: FavouritePhotoViewModelDelegate {
    func didStartLoadingPhotos() {
    
    }
    
    func didFinishLoadingPhotos() {
        for i in viewModel.photos {
            pages.append(self.getViewController(urlStr: i))
        }
    
        if let firstVC = self.pages.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
}
