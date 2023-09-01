//
//  SearchWithFiltersViewController.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 06.08.2023.
//

import UIKit

class SearchWithFiltersViewController: UIViewController {
        
    private let genres: [[String]] = [
        ["-", "0"], ["триллер", "1"], ["драма", "2"], ["криминал", "3"], ["мелодрама", "4"], ["детектив", "5"], ["фантастика", "6"],
        ["приключения", "7"], ["биография", "8"],["фильм-нуар", "9"], ["вестерн", "10"], ["боевик", "11"], ["фэнтези", "12"], ["комедия", "13"],
        ["военный", "14"], ["история", "15"], ["музыка", "16"], ["ужасы", "17"], ["мультфильм", "18"], ["семейный", "19"], ["мюзикл", "20"]
    ]
    
    private let newtorkManager = NetworkManager.shared
    private var filteredFilms = [MovieDetails]()
    
    private var selectedGenre = ""

    
    // MARK: picking genre
    private let genreTitle: UILabel = {
        let title = UILabel()
        title.text = "Choose genre"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let genrePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
        
    // MARK: picking year
    private let yearTitle: UILabel = {
        let title = UILabel()
        title.text = "Choose year from 1950 to 2024"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let yearFromTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "year from"
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let yearToTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "year to"
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    //MARK: picking rating
    
    private let ratingTitle: UILabel = {
        let title = UILabel()
        title.text = "Choose rating from 0 to 10"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let ratingFromTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let ratingToTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // MARK: keyword
    private let keywordTitle: UILabel = {
       let title = UILabel()
        title.text = "Type keywords"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let keywordTextField: UITextField = {
       let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "keywords"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    // MARK: search button
    private let searchButton: UIButton = {
        let grayButton = UIButton(type: .system)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        grayButton.setTitle("Search", for: .normal)
        grayButton.backgroundColor = UIColor.gray
        grayButton.setTitleColor(UIColor.white, for: .normal)
        grayButton.layer.cornerRadius = 8
        return grayButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}

extension SearchWithFiltersViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setConstraints()
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
    }
    
    func addSubviews() {
        view.addSubview(genreTitle)
        view.addSubview(genrePicker)
        view.addSubview(yearTitle)
        view.addSubview(yearFromTextField)
        view.addSubview(yearToTextField)
        view.addSubview(ratingTitle)
        view.addSubview(ratingFromTextField)
        view.addSubview(ratingToTextField)
        view.addSubview(keywordTitle)
        view.addSubview(keywordTextField)
        view.addSubview(searchButton)
    }
    
    func setConstraints() {
        setGenreTitleConstraints()
        setGenrePickerConstraints()
        setYearTitleConstraints()
        setYearToTextFieldConstraints()
        setYearFromTextFieldConstraints()
        setRatingTitleConstraints()
        setRatingFromTextFieldConstraints()
        setRatingToTextFieldConstraints()
        setKeywordTitleConstraints()
        setKeywordTextFieldConstraints()
        setSearchButtonConstraints()
    }
    
    func setGenreTitleConstraints() {
        NSLayoutConstraint.activate([
            genreTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            genreTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setGenrePickerConstraints() {
        NSLayoutConstraint.activate([
            genrePicker.topAnchor.constraint(equalTo: genreTitle.topAnchor, constant: 10),
            genrePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        genrePicker.delegate = self
        genrePicker.dataSource = self
    }
    

    
    func setYearTitleConstraints() {
        NSLayoutConstraint.activate([
            yearTitle.topAnchor.constraint(equalTo: genrePicker.bottomAnchor, constant: 30),
            yearTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setYearFromTextFieldConstraints() {
        NSLayoutConstraint.activate([
            yearFromTextField.topAnchor.constraint(equalTo: yearTitle.bottomAnchor, constant: 20),
            yearFromTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100)
        ])
    }
    
    func setYearToTextFieldConstraints() {
        NSLayoutConstraint.activate([
            yearToTextField.topAnchor.constraint(equalTo: yearTitle.bottomAnchor, constant: 20),
            yearToTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100)
        ])
    }
    
    func setRatingTitleConstraints() {
        NSLayoutConstraint.activate([
            ratingTitle.topAnchor.constraint(equalTo: yearToTextField.bottomAnchor, constant: 30),
            ratingTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setRatingFromTextFieldConstraints() {
        NSLayoutConstraint.activate([
            ratingFromTextField.topAnchor.constraint(equalTo: ratingTitle.bottomAnchor, constant: 20),
            ratingFromTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100)
        ])
    }
    
    func setRatingToTextFieldConstraints() {
        NSLayoutConstraint.activate([
            ratingToTextField.topAnchor.constraint(equalTo: ratingTitle.bottomAnchor, constant: 20),
            ratingToTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100)
        ])
    }
    
    func setKeywordTitleConstraints() {
        NSLayoutConstraint.activate([
            keywordTitle.topAnchor.constraint(equalTo: ratingToTextField.bottomAnchor, constant: 30),
            keywordTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setKeywordTextFieldConstraints() {
        NSLayoutConstraint.activate([
            keywordTextField.topAnchor.constraint(equalTo: keywordTitle.bottomAnchor, constant: 20),
            keywordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func setSearchButtonConstraints() {
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: keywordTextField.bottomAnchor, constant: 50),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: view.frame.size.width/3),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func searchButtonAction() {
        
        guard let selectedYearFrom = yearFromTextField.text, let selectedYearTo = yearToTextField.text else {
            return
        }
        
        guard let selectedRatingFrom = ratingFromTextField.text, let selectedRatingTo = ratingToTextField.text else {
            return
        }
        
        guard let selectedKeyword = keywordTextField.text else {
            return
        }
        
        
//        newtorkManager.searchWithFilters(genre: selectedGenre, yearFrom: selectedYearFrom, yearTo: selectedYearTo, ratingFrom: selectedRatingFrom, ratingTo: selectedRatingTo, keyword: selectedKeyword) { result in
//            switch result {
//            case .success(let success):
//                self.filteredFilms = success.items ?? []
//                print(self.filteredFilms)
//            case .failure(let failure):
//                print(failure)
//            }
//        }
        

    }

}

extension SearchWithFiltersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row][0]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGenre = genres[row][1] 
        
    }
}
