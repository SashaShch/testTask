//
//  BreedPhotoViewController.swift
//  testTask
//
//  Created by SashaShch on 16.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class PhotosListViewController: UIPageViewController {
    var viewModel: PhotosListViewModel!
    
    var pages = [UIViewController] ()
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        navigationItem.title = viewModel.breed
        
        let rightButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(rightButtonAction))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        viewModel.fetchPhotos()
        viewModel.delegate = self;
    }
    
    @objc func rightButtonAction() {
        viewModel.photos[currentIndex].share()
    }
    
    func getViewController(urlStr: String) -> PhotoPageViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhotoPageViewController") as! PhotoPageViewController
        if let url = URL(string: urlStr) {
            vc.imageURL = url
            vc.breedInfo = viewModel.breed
        }
        return vc
    }
}

extension PhotosListViewController: UIPageViewControllerDataSource
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

extension PhotosListViewController: PhotosListViewModelDelegate {
    func didStartFetchingPhotos() {
        
    }
    
    func didFinishFetchingPhotos() {
        for i in self.viewModel.photos {
            self.pages.append(self.getViewController(urlStr: i))
        }
        
        if let firstVC = self.pages.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
}
