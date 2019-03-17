//
//  SwiftMenuPagesViewController.swift
//  SwiftMenuPages
//
//  Created by DinDin on 2019/3/17.
//  Copyright © 2019 DinDin. All rights reserved.
//

import Foundation


protocol JAVPageViewSelectDelegate: class {
    func setIndex(_ number: Int)
}

class JAVPageViewController: UIPageViewController {
    
    private(set) var list = [UIViewController]()
    @objc var pageIndex: Int {
        
        get {
            var currentPageIndex: Int = 0
            if let vc = viewControllers?.first, let pageIndex = list.index(of: vc) {
                currentPageIndex = pageIndex
            }
            
            return currentPageIndex
        }
        
        set {
            guard newValue >= 0, newValue < list.count else { return }
            
            let vc = list[newValue]
            let direction: UIPageViewController.NavigationDirection = newValue < pageIndex ? .reverse : .forward
            
            setViewController(vc, direction: direction)
        }
    }
    
    weak var selectDelegate: JAVPageViewSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }
    
    public func bind(list: [UIViewController], index: Int ,delegate: JAVPageViewSelectDelegate? ) {
        self.list = list
        self.selectDelegate = delegate
        pageIndex = index
    }
    
    public func setIndex(_ index: Int) {
        if index > pageIndex {
            setPageIndex(pageIndex + 1) { (isFinish) in
                if isFinish { self.setIndex(index) }
            }
        } else if  index < pageIndex {
            setPageIndex(pageIndex - 1) { (isFinish) in
                if isFinish { self.setIndex(index) }
            }
        }
    }
    
    private func setPageIndex(_ index: Int, completion: ((Bool) -> Void)? = nil) {
        
        guard index >= 0,  index < list.count else { return }
        let vc = list[index]
        let direction: UIPageViewController.NavigationDirection = index < pageIndex ? .reverse : .forward
        setViewController(vc, direction: direction, completion: completion)
    }
    
    
    private func setViewController(_ viewController: UIViewController, direction: UIPageViewController.NavigationDirection = .forward, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            self.setViewControllers([viewController], direction: direction, animated: false, completion: completion)
        }
        
    }
}


extension JAVPageViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = list.index(of: viewController) else { return nil }
        
        let count = list.count
        
        if count == 2, index == 0 {
            return nil
        }
        
        let prevIndex = (index - 1) < 0 ? count - 1 : index - 1
        
        let pageContentViewController: UIViewController = list[prevIndex]
        
        return pageContentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = list.index(of: viewController) else { return nil }
        
        let count = list.count
        
        if count == 2, index == 1 {
            return nil
        }
        
        let nextIndex = (index + 1) >= count ? 0 : index + 1
        
        let pageContentViewController = list[nextIndex]
        
        return pageContentViewController
    }
}

extension JAVPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.selectDelegate?.setIndex(self.pageIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        
        
    }
    
}
