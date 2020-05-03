//
//  AppCoordinator.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController!
    let splitViewController: UISplitViewController!
    var window: UIWindow
    
    private var masterViewController: MasterViewController!
    private var detailViewController: DetailViewController!
    
    lazy var articlesClient = NetworkClient()
    
    init(appWindow: UIWindow) {
        self.window = appWindow
        self.splitViewController = window.rootViewController as? UISplitViewController
        self.navigationController = splitViewController.viewControllers.first as? UINavigationController
    }
    
    func start() {
        masterViewController = UIStoryboard.instantiateMasterViewController(viewModel: .init(articles: ArticlesPersistence.shared.articles, networkClient: articlesClient, persistence: ArticlesPersistence.shared, coordinator: self))
        detailViewController = UIStoryboard.instantiateDetailViewController(viewModel: .init())
        
        navigationController.viewControllers = [masterViewController]
        
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
        
        if splitViewController.isHorizontallyRegular {
            splitViewController.showDetailViewController(detailViewController, sender: self)
        }
    }
}

extension AppCoordinator: MasterViewNavigation {
    func show(article: Article) {
        detailViewController.viewModel?.inject(selectedArticle: article)
        
        if !splitViewController.isHorizontallyRegular {
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func deleted(article: Article) {
        ArticlesPersistence.shared.delete(article)
        detailViewController.viewModel?.deleted(article: article)
    }
}
