//
//  DogListViewController.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 28/07/2023.
//

import UIKit

protocol DogListViewControllerProtocol {
    func setDogs(dogs: [Dog])
    func showLoading(load: Bool)
}

class DogListViewController: UICollectionViewController, DogListViewControllerProtocol {
    
    init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 15, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Constants
    private enum Constants {
        static let sceneTitle = "Search Results"
        static let pullToRefreshText = "Pull to refresh"
    }
    
    // MARK: - Properties
    
    var dogs = [Dog]()
    var filteredDogs = [Dog]()
    
    var presenter: DogListPresenterProtocol?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.sceneTitle
        return searchController
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constants.pullToRefreshText)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var dataSource: DogListDataSource = {
        return DogListDataSource(dogs: dogs, hasSearchText: { [weak self] in
            return self?.hasSearchText() ?? false
        })
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        collectionView?.dataSource = dataSource
        collectionView?.register(BreedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        title = Constants.sceneTitle
        
        definesPresentationContext = true
        collectionView.refreshControl = refresh
        collectionView.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          activityIndicator.center = collectionView.center
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
            self?.presenter?.fetchDogs { dogs, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let dogs = dogs {
                    print("Fetched dogs: \(dogs)")
                }
            }

            self?.collectionView.reloadData()
            self?.refresh.endRefreshing()
        }
    }
    
    func setDogs(dogs: [Dog]) {
        self.dogs = dogs
        dataSource.updateDogs(dogs)
        self.collectionView.reloadData()
    }
    
    func showLoading(load: Bool) {
        if load {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - TableView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
}

extension DogListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            dataSource.updateFilteredBreeds(with: searchText)
            collectionView.reloadData()
        }
    }
}
