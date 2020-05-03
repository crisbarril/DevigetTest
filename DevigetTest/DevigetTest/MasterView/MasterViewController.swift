//
//  MasterViewController.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    //MARK: Private Properties
    var viewModel: MasterViewModel!
    
    init(viewModel: MasterViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initBinding()
        viewModel.start()
    }
    
    //MARK: Private Method
    private func setupUI() {
        title = "My Articles"
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.refresh()
    }
    
    private func initBinding() {
        viewModel.datasource.subscribe(self, fireNow: false) { [weak self] _ in
            if let self = self, self.viewModel.deleteAll {
                self.tableView.tableFooterView?.isHidden = true
                self.tableView.deleteSections(IndexSet(arrayLiteral: 0), with: .automatic)
                self.viewModel.dismissAllCompleted()
                return
            }
            
            self?.tableView.reloadData()
        }
        
        viewModel.refreshFinished.subscribe(self) { [weak self] refreshFinished in
            if refreshFinished {
                self?.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.showError.subscribe(self) { [weak self] showError in
            if !showError.isEmpty {
                self?.showInfoAlert(title: "Error", message: showError)
            }
        }
        
        viewModel.showMessage.subscribe(self) { [weak self] showMessage in
            if !showMessage.isEmpty {
                self?.showInfoAlert(title: "Info Message", message: showMessage)
            }
        }
        
        viewModel.deleteRow.subscribe(self) { [weak self] (deleteRow) in
            if let deleteRow = deleteRow {
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: [IndexPath(row: deleteRow, section: 0)], with: .left)
                self?.tableView.endUpdates()
            }
        }
    }
    
    @objc private func dismissAllButtonPressed() {
        viewModel.dismissAll()
    }
}

//MARK: UITableview Delegate and Datasource Methods
extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Fetch more if we reach the last row
        if indexPath.row == viewModel.datasource.value.count-1 {
            if viewModel.hasMorePages() {
                guard !viewModel.requestInProgress else {
                    return
                }
                
                viewModel.fetchPage()
                
                let indicator = UIActivityIndicatorView(style: .large)
                indicator.color = .blue
                indicator.startAnimating()
                indicator.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

                tableView.tableFooterView = indicator
                tableView.tableFooterView?.isHidden = false
                
            } else {
                print("No more articles to fetch.")

                let lblMessage = UILabel.init(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44)))
                lblMessage.text = "Limit of 50 articles reached"
                lblMessage.textAlignment = .center
                lblMessage.textColor = .gray

                tableView.tableFooterView = lblMessage
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowViewModel = viewModel.getRowViewModel(indexPath) else {
            fatalError()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier(viewModel: rowViewModel), for: indexPath)
        
        if let cell = cell as? CellConfigurable {
            cell.populate(viewModel: rowViewModel)
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard viewModel.numberOfRows(section) > 0 else {
            return nil
        }
        
        let dismissAllButton = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        dismissAllButton.backgroundColor = .red
        dismissAllButton.setTitle("Dismiss all", for: .normal)
        dismissAllButton.addTarget(self, action: #selector(dismissAllButtonPressed), for: .touchUpInside)

        return dismissAllButton
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowViewModel = viewModel.getRowViewModel(indexPath)
        if let rowViewModel = rowViewModel as? ViewModelPressible {
            rowViewModel.cellPressed()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
