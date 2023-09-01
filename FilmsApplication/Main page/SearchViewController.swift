//
//  SearchViewController.swift
//  FilmsProject
//
//  Created by Тимур Жексимбаев on 19.07.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    var films = [Film]()
    let networkManager = NetworkManager.shared
    
    private let genres: [[String]] = [
        ["-", "0"], ["триллер", "1"], ["драма", "2"], ["криминал", "3"], ["мелодрама", "4"], ["детектив", "5"], ["фантастика", "6"],
        ["приключения", "7"], ["биография", "8"],["фильм-нуар", "9"], ["вестерн", "10"], ["боевик", "11"], ["фэнтези", "12"], ["комедия", "13"],
        ["военный", "14"], ["история", "15"], ["музыка", "16"], ["ужасы", "17"], ["мультфильм", "18"], ["семейный", "19"], ["мюзикл", "20"]
    ]
    
    private var selectedGenre = ""
    
    // MARK: texts
    var searchText: UILabel = {
        var text = UILabel()
        text.text = "Search for a film"
        text.font = .systemFont(ofSize: 25, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // MARK: text field for searching a film
    var searchField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.placeholder = "Enter search query"
        return field
    }()
    
    // MARK: buttons
    var searchButton: UIButton = {
        let grayButton = UIButton(type: .system)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        grayButton.setTitle("Search", for: .normal)
        grayButton.backgroundColor = UIColor.gray
        grayButton.setTitleColor(UIColor.white, for: .normal)
        grayButton.layer.cornerRadius = 8
        return grayButton
    }()
    
    var randomFilmText: UILabel = {
        var text = UILabel()
        text.text = "Get random film"
        text.font = .systemFont(ofSize: 25, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var randomFilmButton: UIButton = {
        let grayButton = UIButton(type: .system)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        grayButton.setTitle("Tap Me", for: .normal)
        grayButton.backgroundColor = UIColor.gray
        grayButton.setTitleColor(UIColor.white, for: .normal)
        grayButton.layer.cornerRadius = 8
        return grayButton
    }()
    
    var filterFilmTitle: UILabel = {
        var text = UILabel()
        text.text = "Get film by filters"
        text.font = .systemFont(ofSize: 25, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var filtersFilmButton: UIButton = {
        let grayButton = UIButton(type: .system)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        grayButton.setTitle("Tap Me", for: .normal)
        grayButton.backgroundColor = .lightGray
        grayButton.setTitleColor(UIColor.white, for: .normal)
        grayButton.layer.cornerRadius = 8
        return grayButton
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        addTapGesture()
    }
}


// MARK: setup UI
extension SearchViewController {
    
    func setupUI() {
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        view.addSubview(searchText)
        view.addSubview(searchField)
        view.addSubview(searchButton)
        view.addSubview(randomFilmText)
        view.addSubview(randomFilmButton)
        view.addSubview(filterFilmTitle)
        view.addSubview(filtersFilmButton)
        
        addButtonActions()
    }
    
    func setupLayout() {
        setSearchTextConstraints()
        setSearchButtonConstraints()
        setSearchFieldConstraintss()
        setRandomTextFieldConstraints()
        setRandomFilmButtonConstraints()
        setFilterFilmsTitleConstraints()
        setFilterFilmButtonConstraints()
        
    }
    
    func addButtonActions() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        randomFilmButton.addTarget(self, action: #selector(randomFilmButtonTapped), for: .touchUpInside)
        filtersFilmButton.addTarget(self, action: #selector(selectFilters), for: .touchUpInside)
    }
    
    
    func setSearchTextConstraints() {
        NSLayoutConstraint.activate([
            searchText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setSearchFieldConstraintss() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: searchText.bottomAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            searchField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setSearchButtonConstraints() {
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: 10),
            searchButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    func setRandomTextFieldConstraints() {
        NSLayoutConstraint.activate([
            randomFilmText.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 100),
            randomFilmText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setRandomFilmButtonConstraints() {
        NSLayoutConstraint.activate([
            randomFilmButton.topAnchor.constraint(equalTo: randomFilmText.bottomAnchor, constant: 20),
            randomFilmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomFilmButton.widthAnchor.constraint(equalToConstant: 100),
            randomFilmButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setFilterFilmsTitleConstraints() {
        NSLayoutConstraint.activate([
            filterFilmTitle.topAnchor.constraint(equalTo: randomFilmButton.bottomAnchor, constant: 50),
            filterFilmTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setFilterFilmButtonConstraints() {
        NSLayoutConstraint.activate([
            filtersFilmButton.topAnchor.constraint(equalTo: filterFilmTitle.bottomAnchor, constant: 20),
            filtersFilmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersFilmButton.widthAnchor.constraint(equalToConstant: 100),
            filtersFilmButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    


}

// MARK: buttons actions
extension SearchViewController {
    
    
    // MARK: action for random film button
    @objc func randomFilmButtonTapped() {
        let index = Int.random(in: 0...239)
        let openCell = DetailViewController()
        let randomFilm = DataController.shared.getFilms()[index]
        
        openCell.configure(movie: randomFilm)
        navigationController?.pushViewController(openCell, animated: true)
    }
    
    @objc func selectFilters() {
        present(SearchWithFiltersViewController(), animated: true)
    }
    
    func checkForNils(film: Film) -> Bool {
        
        guard let _ = film.nameRu else {
            print("Has no name")
            return false
        }
        
        guard let _ = film.rating else {
            print("Has no rating")
            return false
        }
        
        guard let _ = film.filmLength else {
            print("Has no length")
            return false
        }
        
        guard let _ = film.year else {
            print("Has no year")
            return false
        }
        guard let genres = film.genres, let _ = genres[0].genre else {
            print("Has no genre")
            return false
        }
        
        guard let url = film.posterUrl, let _ = URL(string: url) else {
            print("Invalid poster URL")
            return false
        }
        
        return true
    }
    
    func performSearch(query: String) {
        films = [Film]()
        
        networkManager.search(keyword: query.replacingOccurrences(of: " ", with: "")) { result in
            switch result {
            case .success(let success):
                for film in success.films ?? [] {
                    if self.checkForNils(film: film) {
                        self.films.append(film)
                    }
                }
                
                if self.films.count == 0 {
                    let alert = UIAlertController(title: "Alert", message: "Wrong title of the film or film is not found, please try again", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let openCell = AllMoviesViewController()
                    openCell.foundFilms(films: self.films)
                    self.navigationController?.pushViewController(openCell, animated: true)
                }
                
            case .failure(let failure):
                print(failure)
            }
        }
        

        
    }
    
    @objc func searchButtonTapped() {
        
        guard let query = searchField.text else {
            return
        }
        
        performSearch(query: query)
        
    }
}

// MARK: set tap gestures
extension SearchViewController {
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


