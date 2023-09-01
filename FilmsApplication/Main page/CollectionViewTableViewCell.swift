
import UIKit
import SDWebImage

// MARK: film cell
class FilmCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    public let posterImageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 4
        return image
    }()
    
    private let yearLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = .preferredFont(forTextStyle: .footnote)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let genreLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = .preferredFont(forTextStyle: .footnote)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 4
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(posterImageView)
        contentView.addSubview(genreLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            // poster of the film
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            
            // title of the film
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 1),
            titleLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -1),
            
            
            // year of the film
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 1),
            
            // genre of the film
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            genreLabel.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 1),
            
        ])
        
    }
    
    
    func configure(with film: Film) {
        
        guard let name = film.nameRu else {
            print("Has no name")
            return
        }
        
        guard let year = film.year else {
            print("Has no year")
            return
        }
        
        guard let genres = film.genres, genres.count != 0, let genre = genres[0].genre else {
            print("Has no genre")
            return
        }
    
        
        guard let url = film.posterUrl, let imageURL = URL(string: url) else {
            print("Invalid poster URL")
            return
        }
        
        DispatchQueue.main.async {
            self.posterImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "square.and.arrow.up"))
            self.titleLabel.text = name
            self.yearLabel.text = year + ", "
            self.genreLabel.text = genre
        }
        
    }
}


