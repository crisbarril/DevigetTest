//
//  PickConversationViewModel.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

class MasterViewModel {
    
    //MARK: Bindable properties
    let refreshFinished = Observable<Bool>(value: false)
    let showError = Observable<String>(value: "")
    let showMessage = Observable<String>(value: "")
    let datasource = Observable<[RowViewModel]>(value: [])
    let deleteRow = Observable<Int?>(value: nil)

    //MARK: Public properties
    private(set) var deleteAll: Bool = false
    private(set) var requestInProgress: Bool = false
    
    //MARK: Private properties
    private let networkClient: NetworkClientProtocol
    private var persistence: ArticlesPersistenceProtocol
    private weak var coordinator: MasterViewNavigation!
    private weak var articlesDatasource: Observable<Set<Article>>!

    init(articles: Set<Article>, networkClient: NetworkClientProtocol, persistence: ArticlesPersistenceProtocol, coordinator: MasterViewNavigation) {
        self.coordinator = coordinator
        self.networkClient = networkClient
        self.persistence = persistence
        
        updateDatasource(articles: articles)
    }
    
    func start() {
        refresh()
    }
    
    func dismissAll() {
        deleteAll = true // Delete row animation
        datasource.value = []
        persistence.articles = []
        persistence.save()
    }
    
    func dismissAllCompleted() {
        deleteAll = false
    }
    
    func hasMorePages() -> Bool {
        guard !deleteAll else {
            return false
        }
        
        // Wants to show 50 articles
        return datasource.value.count < 50
    }
    
    func refresh() {
        requestInProgress = true
        networkClient.getTopArticles { [weak self] (articles, result) in
            switch result {
            case .success:
                guard let self = self else {
                    return
                }
                
                guard let articles = articles else {
                    self.showError.value = "No new articles"
                    self.refreshFinished.value = true
                    self.requestInProgress = false
                    return
                }
                
                // Persist new articles
                for article in articles {
                    self.persistence.articles.insert(article)
                }
                
                self.persistence.save()
                
                // Update table datasource
                self.updateDatasource(articles: self.persistence.articles)
                
            case .failure(let error):
                self?.showError.value = error
            }
            
            self?.refreshFinished.value = true
            self?.requestInProgress = false
        }
    }
    
    func fetchPage() {
        requestInProgress = true
        networkClient.getNextPage { [weak self] (articles, result) in
            switch result {
            case .success:
                guard let self = self else {
                    return
                }
                
                guard let articles = articles else {
                    self.showError.value = "No new articles"
                    self.requestInProgress = false
                    return
                }
                
                // Persist new articles
                for article in articles {
                    self.persistence.articles.insert(article)
                }
                self.persistence.save()
                
                // Update table datasource
                self.updateDatasource(articles: self.persistence.articles)
                
            case .failure(let error):
                self?.showError.value = error
            }
            
            self?.requestInProgress = false
        }
    }
    
    private func updateDatasource(articles: Set<Article>) {
        let viewModels: [RowViewModel] = articles.sorted(by: { $0.entryDate > $1.entryDate }).map({
            let article = $0
            
            return MasterTableCellViewModel(article: article, cellPressed: { [weak self] in
                article.readStatus.value = true
                self?.persistence.save()
                self?.coordinator.show(article: article)
            }, deleteButtonPressed: { [weak self] in
                // Delete row animation
                let deleteRowIndex = self?.datasource.value.map({ $0 as? MasterTableCellViewModel }).firstIndex(where: { $0?.article == article })
                self?.deleteRow.value = deleteRowIndex
                self?.coordinator.deleted(article: article)                
            })
        })
        
        datasource.value = viewModels
    }
}

extension MasterViewModel: TableViewModel {
    func supportedCells() -> [CellConfigurable.Type] {
        return [MasterTableCell.self]
    }
    
    func numberOfSections() -> Int {
        guard !deleteAll else {
            return 0
        }
        
        return  1
    }
    
    func numberOfRows(_ section: Int) -> Int {
        if let rowToDelete = deleteRow.value {
            datasource.value.remove(at: rowToDelete)
            deleteRow.value = nil
        }
        
        return datasource.value.count
    }
    
    func getRowViewModel(_ indexPath: IndexPath) -> RowViewModel? {
        return datasource.value[indexPath.row]
    }
    
    func cellIdentifier(viewModel: RowViewModel) -> String {
        switch viewModel {
        case is MasterTableCellViewModel:
            return MasterTableCell.reuseIdentifier
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}
