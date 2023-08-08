//
//  DogListDetailViewController.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import UIKit

protocol DogListDetailViewControllerProtocol {
    func setDogs(dogs: [Dog])
    func showLoading(load: Bool)
}

class DogListDetailViewController: UITableViewController, DogListDetailViewControllerProtocol {
    
    // Constants
    private enum Constants {
        static let sceneTitle = "Dog List"
        static let searchTitle = "Search by name"
        static let pullToRefreshText = "Pull to refresh"
    }
    
    // MARK: - Properties
    
    var dogs = [Dog]()
    var filteredDogs = [Dog]()
    
    var presenter: DogListDetailPresenterProtocol?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchTitle
        return searchController
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constants.pullToRefreshText)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var dataSource: DogListDetailDataSource = {
        return DogListDetailDataSource(dogs: dogs, hasSearchText: { [weak self] in
            return self?.hasSearchText() ?? false
        })
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.dataSource = dataSource
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: "BreedCell")
        title = Constants.sceneTitle
        
        definesPresentationContext = true
        tableView.refreshControl = refresh
        tableView.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = tableView.center
    }
    
    // MARK: - Helpers
    private func hasSearchText() -> Bool {
        if let text = searchController.searchBar.text {
            return !text.isEmpty
        }
        return false
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.fetchDogs(page: 1)
        }
    }
    
    func setDogs(dogs: [Dog]) {
        self.dogs = dogs
        dataSource.updateDogs(dogs)
        self.tableView.reloadData()
        self.refresh.endRefreshing()
    }
    
    func showLoading(load: Bool) {
        if load {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
}

extension DogListDetailViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            dataSource.updateFilteredBreeds(with: searchText)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dogs.count - 1 {
            presenter?.loadMoreDogs()
        }
    }
}

