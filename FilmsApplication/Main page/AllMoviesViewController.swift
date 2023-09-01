//
//  AllMoviesViewController.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 27.07.2023.
//

import UIKit

class AllMoviesViewController: UIViewController {
    
    var allFilms = DataController.shared.getFilms()
        {
        didSet {
            table.reloadData()
        }
    }
    

    var filteredFilms = [Film]() {
        didSet {
            table.reloadData()
        }
    }
    
    private let networkManager = NetworkManager.shared
        
    private lazy var searchController: UISearchController = {
       var searchcontroller = UISearchController(searchResultsController: nil)
        searchcontroller.loadViewIfNeeded()
        searchcontroller.searchResultsUpdater = self
        searchcontroller.searchBar.delegate = self
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.searchBar.enablesReturnKeyAutomatically = false
        searchcontroller.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        
        return searchcontroller
    }()
    
    private var table: UITableView = {
        let table = UITableView()
        table.register(AllMoviesTableViewCell.self, forCellReuseIdentifier: "AllMoviesCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
//        networkManager.getAllMovies() { result in
//            switch result {
//            case .success(let success):
//                self.allFilms.append(contentsOf: success.films ?? [])
//                if self.allFilms.count == 240 {
//                    for film in self.allFilms {
//                        DataController.shared.createFilm(topFilm: film)
//                    }
//                }
//            case .failure(let failure):
//                print(failure)
//            }
//        }
//        
//        DataController.shared.deleteAllFilms()
        
        view.backgroundColor = .systemBackground
        view.addSubview(table)
        navigationItem.searchController = searchController
        table.delegate = self
        table.dataSource = self
        setupLayout()
        
        
    }
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func foundFilms(films: [Film]) {
        allFilms = films
    }

}


extension AllMoviesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive || searchController.searchBar.text != "" {
            return filteredFilms.count
        }
        
        return allFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "AllMoviesCell", for: indexPath) as? AllMoviesTableViewCell else {
            return UITableViewCell()
        }
        
        var film = Film.example
        
        if searchController.isActive || searchController.searchBar.text != "" {
            film = filteredFilms[indexPath.row]
        } else {
            film = allFilms[indexPath.row]
        }

        cell.configure(with: film)
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 155
           
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cellFilm: Film
        if searchController.isActive || searchController.searchBar.text != "" {
            cellFilm = filteredFilms[indexPath.row]
        } else {
            cellFilm = allFilms[indexPath.row]
        }
        let openCell = DetailViewController()
        openCell.configure(movie: cellFilm)
        navigationController?.pushViewController(openCell, animated: true)
        
    }

}

extension AllMoviesViewController: UISearchBarDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filter(text: searchText)
    }
    
    func filter(text: String) {
        filteredFilms = allFilms.filter { film in
            if (searchController.searchBar.text != "") {
                let searchTextMatch = film.nameRu?.lowercased().contains(text.lowercased())
                return searchTextMatch!
            } else {
                return false
            }
        }
        
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(for: searchController)
    }
}
