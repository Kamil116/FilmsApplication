//
//  ViewController.swift
//  FilmsProject
//
//  Created by Тимур Жексимбаев on 19.07.2023.
//

import UIKit


class HomeViewController: UIViewController {
    
    let networkManager = NetworkManager.shared
    
    let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("see all", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var topFilms = [Film]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    // Create a UICollectionView with a vertical scroll layout
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: "FilmCell")
        
        collectionView.layer.cornerRadius = 10
        
        return collectionView
    }()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        seeAllButton.removeFromSuperview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        
        networkManager.getTopMovies() { result in
            switch result {
            case .success(let success):
                self.topFilms = success.films ?? []
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}

// MARK: setup UI
extension HomeViewController {
    func setupUI() {
        setupViews()
        setupLayout()
        
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        addButtonActions()
    }
    
    func addButtonActions() {
        seeAllButton.addTarget(self, action: #selector(goToAllMovies), for: .touchUpInside)
    }
    
    func setupLayout() {
        setCollectionViewConstraints()
    }
    
    func setCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Popular movies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: seeAllButton)
    }
    
}

// MARK: button actions
extension HomeViewController {
    
    @objc func goToAllMovies() {
        let newController = AllMoviesViewController()
        newController.title = "Movies"
        navigationController?.pushViewController(newController, animated: true)
        
    }
}


// MARK: collection of films
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topFilms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? FilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let film = topFilms[indexPath.item]
        
        cell.configure(with: film)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellFilm = topFilms[indexPath.item]
        let openCell = DetailViewController()
        openCell.configure(movie: cellFilm)
        navigationController?.pushViewController(openCell, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.bounds.width/2, height: self.collectionView.bounds.height/2.8)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}
