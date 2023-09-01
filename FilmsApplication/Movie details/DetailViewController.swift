import UIKit
import WebKit

/// Экран детального описания фильма
final class DetailViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Constants

    private enum Constants {
        static let defaultBlack = "defaultBlack"
        static let defaultOrange = "defaultOrange"
        static let watchText = "Смотреть"
        static let shareButtonImageName = "square.and.arrow.up"
        static let clearString = ""
        static let ratingText = "Оценка пользователей - "
        static let fatalErrorText = "init(coder:) has not been implemented"
        static let errorText = "Error"
        static let okText = "Ok"
        static let emptyString = ""
        static let watchButtonCornerRadiusValue = 9.0
        static let watchButtonBorderWidthValue = 1.0
        static let movieRatingLabelFontSizeValue = 25.0
        static let movieRatingTopAnchorValue = 10.0
        static let movieRatingHeightAnchorValue = 50.0
        static let watchButtonLeftAnchorValue = 10.0
        static let watchButtonTopAnchorValue = 20.0
        static let watchButtonWidthAnchorValue = -20.0
        static let watchButtonHeightAnchorValue = 50.0
        static let movieImageViewHeightAnchorValue = 460.0
        static let movieImageViewLeftAnchorValue = 0.0
        static let scrollViewBottomAnchorValue = 100.0
        static let movieDescriptionLabelWidthAnchorValue = -10.0
        static let movieDescriptionLabelLeftAnchorValue = 5.0
        static let movieDescriptionLabelRightAnchorValue = -5.0
        static let movieDescriptionLabelBottomAnchorValue = -100.0
    }
    
    let networkService = NetworkManager()
    var webView: WKWebView!
    
    

    // MARK: Private Visual Components

    private let movieImageView: UIImageView = {
        let movieImageView = UIImageView()
        movieImageView.contentMode = .scaleToFill
        movieImageView.translatesAutoresizingMaskIntoConstraints = false

        return movieImageView
    }()

    private let movieDescriptionLabel: UILabel = {
        let movieDescriptionLabel = UILabel()
        movieDescriptionLabel.numberOfLines = 0
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return movieDescriptionLabel
    }()

    private let watchButton: UIButton = {
        let watchButton = UIButton(type: .system)
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        watchButton.setTitle(Constants.watchText, for: .normal)
        watchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        watchButton.backgroundColor = UIColor(named: Constants.defaultOrange)
        watchButton.setTitleColor(UIColor.black, for: .normal)
        watchButton.layer.cornerRadius = CGFloat(Constants.watchButtonCornerRadiusValue)
        watchButton.layer.borderColor = UIColor.orange.cgColor
        watchButton.layer.borderWidth = CGFloat(Constants.watchButtonBorderWidthValue)
        return watchButton
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()

    private let movieRatingLabel: UILabel = {
        let movieRatingLabel = UILabel()
        movieRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        movieRatingLabel.font = .boldSystemFont(ofSize: CGFloat(Constants.movieRatingLabelFontSizeValue))
        movieRatingLabel.textColor = UIColor.orange
        movieRatingLabel.textAlignment = .center
        return movieRatingLabel
    }()
    
    private let starButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var movieTitle = ""
    var movieURl = ""
    
    var selectFilm = Film.example
    

    // MARK: - Public Properties

    var movieDetails: MovieDetails?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initMethods()

    }

    // MARK: - Private Methods

    @objc private func shareButtonAction() {
        showMovieActivity(movieName: movieTitle)
    }
    
    @objc private func watchButtonAction() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        guard let url = URL(string: movieURl) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc private func starButtonAction() {
        starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        for film in LikedFilmsDataController.shared.getFilms() {
            if selectFilm.filmId == film.filmId {
                showAlert()
                return 
            }
        }
        
        LikedFilmsDataController.shared.createFilm(topFilm: selectFilm)

    }
    
    func showAlert() {
        let pickedFilmAlert = UIAlertController(title: "Warning", message: "You have already chosen this film", preferredStyle: .alert)
        pickedFilmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(pickedFilmAlert, animated: true)
    }
    
    func configure(movie: Film) {

        selectFilm = movie

        navigationItem.title = movie.nameRu ?? ""
        movieTitle = movie.nameRu ?? ""

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: movie.posterUrl!)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.movieImageView.image = image
                    }
                }
            }
        }

        networkService.fetchSimilarMovies(idMovie: movie.filmId ?? 0) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                self?.movieRatingLabel.text = "Рейтинг: \(movieDetails.ratingImdb ?? 0.0)"
                self?.movieDescriptionLabel.text = movieDetails.shortDescription
                self?.movieURl = movieDetails.webUrl ?? ""
            case .failure(let failure):
                print("error")
            }
        }
    }
    
    func configure(id: Int) {

        

//        navigationItem.title = movie.nameRu ?? ""
//        movieTitle = movie.nameRu ?? ""
//
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: URL(string: movie.posterUrl!)!) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self!.movieImageView.image = image
//                    }
//                }
//            }
//        }

        networkService.fetchSimilarMovies(idMovie: id) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                self?.movieRatingLabel.text = "Рейтинг: \(movieDetails.ratingImdb ?? 0.0)"
                self?.movieDescriptionLabel.text = movieDetails.shortDescription
                self?.movieURl = movieDetails.webUrl ?? ""
                self?.navigationItem.title = movieDetails.nameRu ?? ""
                self?.movieTitle = movieDetails.nameRu ?? ""
                DispatchQueue.global().async { [weak self] in
                    let urlString = movieDetails.posterURL
                    guard let urlString = urlString, let url = URL(string: urlString) else {
                        return
                    }
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.movieImageView.image = image
                            }
                        }
                    }
                }
                
            case .failure(let failure):
                print("error")
            }
        }
    }
    
    
    private func initMethods() {
        setupScrollView()
        setupView()
        setupNavigationBar()
        setConstraints()
    }

    private func setConstraints() {
        createRatingLabelConstraints()
        createWatchButtonConstraints()
        createMovieImageViewConstraints()
        createScrollViewConstraints()
        createRatingLabelConstraints()
        createMovieDescriptionLabelConstraints()
        createStarButtonConstraints()
    }
    

    private func createWatchButtonConstraints() {
        watchButton.leftAnchor
            .constraint(equalTo: scrollView.leftAnchor, constant: CGFloat(Constants.watchButtonLeftAnchorValue)).isActive = true
        watchButton.topAnchor.constraint(
            equalTo: movieImageView.bottomAnchor,
            constant: CGFloat(Constants.watchButtonTopAnchorValue)
        ).isActive = true
        watchButton.widthAnchor.constraint(
            equalTo: scrollView.widthAnchor,
            constant: CGFloat(Constants.watchButtonWidthAnchorValue)
        ).isActive = true
        watchButton.heightAnchor.constraint(equalToConstant: CGFloat(Constants.watchButtonHeightAnchorValue)).isActive = true
    }

    private func createMovieImageViewConstraints() {
        movieImageView.leftAnchor.constraint(
            equalTo: scrollView.leftAnchor,
            constant: CGFloat(Constants.movieImageViewLeftAnchorValue)
        ).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        movieImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: CGFloat(Constants.movieImageViewHeightAnchorValue)).isActive = true
        
        print(view.frame.width)
    }

    private func createScrollViewConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }

    private func createMovieDescriptionLabelConstraints() {
        movieDescriptionLabel.topAnchor.constraint(equalTo: movieRatingLabel.bottomAnchor, constant: 15).isActive = true
        movieDescriptionLabel.widthAnchor.constraint(
            equalTo: view.widthAnchor,
            constant: CGFloat(Constants.movieDescriptionLabelWidthAnchorValue)
        ).isActive = true
        movieDescriptionLabel.leftAnchor.constraint(
            equalTo: scrollView.leftAnchor,
            constant: CGFloat(Constants.movieDescriptionLabelLeftAnchorValue)
        ).isActive = true
        movieDescriptionLabel.rightAnchor.constraint(
            equalTo: scrollView.rightAnchor,
            constant: CGFloat(Constants.movieDescriptionLabelRightAnchorValue)
        ).isActive = true
        movieDescriptionLabel.bottomAnchor.constraint(
            equalTo: scrollView.bottomAnchor,
            constant: CGFloat(Constants.movieDescriptionLabelBottomAnchorValue)
        ).isActive = true
    }

    private func createRatingLabelConstraints() {
        movieRatingLabel.topAnchor.constraint(
            equalTo: watchButton.bottomAnchor,
            constant: CGFloat(Constants.movieRatingTopAnchorValue)
        ).isActive = true
        movieRatingLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        movieRatingLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        movieRatingLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        movieRatingLabel.heightAnchor.constraint(equalToConstant: CGFloat(Constants.movieRatingHeightAnchorValue))
            .isActive = true
    }
    
    private func createStarButtonConstraints() {
        NSLayoutConstraint.activate([
            starButton.topAnchor.constraint(equalTo: watchButton.bottomAnchor, constant: CGFloat(Constants.movieRatingTopAnchorValue)),
            starButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }

    private func setupScrollView() {
        scrollView.addSubview(watchButton)
        scrollView.addSubview(movieImageView)
        scrollView.addSubview(movieDescriptionLabel)
        scrollView.addSubview(movieRatingLabel)
        scrollView.addSubview(starButton)
    }

    private func setupView() {
        view.addSubview(scrollView)
        view.backgroundColor = .white
    }

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(systemName: Constants.shareButtonImageName), for: .normal)
        shareButton.tintColor = UIColor(named: Constants.defaultOrange)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        watchButton.addTarget(self, action: #selector(watchButtonAction), for: .touchUpInside)
        starButton.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
}

/// Расширение для расшаривания фильма
extension DetailViewController {
    func showMovieActivity(movieName: String) {
        let items = [URL(string: movieName)]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
