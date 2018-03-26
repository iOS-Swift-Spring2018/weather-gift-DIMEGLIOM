//
//  PageVC.swift
//  WeatherGift
//
//  Created by Mark on 3/26/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    var currentPage = 0
    var locationsArray = ["Local City Weather","Chestnut Hill, MA","Sydney, Australia","Accra, Ghana","Uglich"]
    var pageControl: UIPageControl!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    var listButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configurePageControl()
        configureListButton()
    }
    
    
    func configurePageControl() {
        
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        view.addSubview(pageControl)
        
    }
    
    func configureListButton() {
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setImage(UIImage(named: "listbutton"), for: .normal)
        listButton.setImage(UIImage(named: "listbutton-highlighted"), for: .highlighted)
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        view.addSubview(listButton)
    }
    
    
    // MARK: SEGWAY HERE
    @objc func segueToListVC() {
        
        performSegue(withIdentifier: "ToListVC", sender: nil)
        
    }
    
    
    
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListVC" {
            
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
        }
        
    }
    
    // MARK: create VC for page VC
    func createDetailVC(forPage page: Int) -> DetailVC {
        
         currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
        
    }
    
    

}


extension PageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC {
            
            if currentViewController.currentPage < locationsArray.count - 1 {
                
                return createDetailVC(forPage: currentViewController.currentPage + 1)
                
            }
            
        }
        
        return nil
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC {
            
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
                
            }
            
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC {
            
            pageControl.currentPage = currentViewController.currentPage
            
        }
        
    }
    
    
}