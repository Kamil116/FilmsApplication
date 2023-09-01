//
//  DescriptionViewController.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 13.08.2023.
//

import UIKit

class DescriptionViewController: UIViewController {
    private var movieGenres: [Genre] = []
    
    private let scrollView = UIScrollView()
    private let mainInfo = UIView()
    private let moviePoster = UIImageView()
    private let movieTitle = UILabel()
    private let movieSubtitle = UILabel()
    private let genreStack = UIStackView()
    private let movieDescription = UITextView()
    private let movieDirector = UILabel()
    private let actorsTitle = UILabel()
    private let seeAllButton = UIButton()
    private let actorsTable = UITableView()
    private let similarMoviesTitle = UILabel()
    private let browseAllButton = UIButton()
//    private let similarMoviesCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension DescriptionViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupMainInfo()
        
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainInfo)
        scrollView.addSubview(actorsTitle)
        scrollView.addSubview(seeAllButton)
        scrollView.addSubview(actorsTable)
        scrollView.addSubview(similarMoviesTitle)
        scrollView.addSubview(browseAllButton)
//        scrollView.addSubview(similarMoviesCollectionView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func setupMainInfo() {
        mainInfo.addSubview(moviePoster)
        mainInfo.addSubview(movieTitle)
        mainInfo.addSubview(movieSubtitle)
        mainInfo.addSubview(genreStack)
        mainInfo.addSubview(movieDescription)
        mainInfo.addSubview(movieDirector)
        
        mainInfo.frame = CGRect(x: 0, y: 0, width: 330, height: 130)
        mainInfo.backgroundColor = .red
        mainInfo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainInfo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            mainInfo.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12),
            mainInfo.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -12)
        ])
        
        setupMoviePoster()
        setupMovieTitle()
        setupMovieSubtitle()
        setupGenreStack()
        setupMovieDescription()
        setupMovieDirector()
    }
    
    func setupMoviePoster() {
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.image = UIImage(systemName: "square.and.arrow.up")
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: mainInfo.topAnchor, constant: 20),
            moviePoster.leftAnchor.constraint(equalTo: mainInfo.leftAnchor, constant: 20),
        ])
    }
    
    func setupMovieTitle() {
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.font = .preferredFont(forTextStyle: .headline)
        movieTitle.text = "Интерстеллар"
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: moviePoster.topAnchor),
            movieTitle.leftAnchor.constraint(equalTo: moviePoster.rightAnchor, constant: 20),
        ])
    }
    
    func setupMovieSubtitle() {
        movieSubtitle.translatesAutoresizingMaskIntoConstraints = false
        movieSubtitle.font = .preferredFont(forTextStyle: .subheadline)
        movieSubtitle.text = "Interstellar"
        movieSubtitle.layer.opacity = 4
        NSLayoutConstraint.activate([
            movieSubtitle.topAnchor.constraint(equalTo: movieTitle.topAnchor, constant: 20),
            movieSubtitle.leftAnchor.constraint(equalTo: moviePoster.rightAnchor, constant: 20),
        ])
    }
    
    func setupGenreStack() {
        for movieGenre in movieGenres {
            var genre = UILabel()
//            genre.text = movieGenre ?? ""
            genre.layer.borderWidth = CGFloat(0.1)
            genre.backgroundColor = .systemGray5
            genre.tintColor = .black
            genre.translatesAutoresizingMaskIntoConstraints = false
            genre.layer.cornerRadius = 4.0
            genre.textAlignment = .center
            genreStack.addArrangedSubview(genre)
        }
        
        genreStack.translatesAutoresizingMaskIntoConstraints = false
        genreStack.alignment = .center
        genreStack.spacing = 8
        genreStack.topAnchor.constraint(equalTo: movieDirector.bottomAnchor, constant: 20).isActive = true
        genreStack.leftAnchor.constraint(equalTo: moviePoster.rightAnchor, constant: 20).isActive = true
    }
    
    func setupMovieDescription() {
        movieDescription.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupMovieDirector() {
        movieDirector.translatesAutoresizingMaskIntoConstraints = false
        movieDirector.text = "Director: Christopher Nolan"
        movieDirector.font = .preferredFont(forTextStyle: .callout)
        NSLayoutConstraint.activate([
            movieDirector.topAnchor.constraint(equalTo: movieSubtitle.bottomAnchor, constant: 20),
            movieDirector.leftAnchor.constraint(equalTo: moviePoster.rightAnchor, constant: 20),
        ])
    }
}
