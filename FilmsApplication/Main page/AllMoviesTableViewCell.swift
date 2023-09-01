//
//  AllMoviesTableViewCell.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 27.07.2023.
//

import UIKit

import SDWebImage

class AllMoviesTableViewCell: UITableViewCell {
    
    private var posterURL: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 4
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var title: UILabel = {
        let title = UILabel()
        title.font = .preferredFont(forTextStyle: .title3)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        return title
    }()
    
    private var genre: UILabel = {
        let genre = UILabel()
        genre.font = .preferredFont(forTextStyle: .footnote)
        genre.translatesAutoresizingMaskIntoConstraints = false
        return genre
    }()
    
    private var year: UILabel = {
        let year = UILabel()
        year.font = .preferredFont(forTextStyle: .footnote)
        year.translatesAutoresizingMaskIntoConstraints = false
        return year
    }()
    
    private var length: UILabel = {
        let length = UILabel()
        length.font = .preferredFont(forTextStyle: .body)
        length.translatesAutoresizingMaskIntoConstraints = false
        return length
    }()

    private var rating: UILabel = {
        let rate = UILabel(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        rate.layer.cornerRadius = 5
        rate.textAlignment = .center
        rate.font = .preferredFont(forTextStyle: .body)
        rate.textColor = .orange
        rate.translatesAutoresizingMaskIntoConstraints = false
        return rate
    }()


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCellShadow()
        setCellCornerRadius()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
        
    }
    
    func configure(with film: Film) {
        
        guard let name = film.nameRu else {
            print("Has no name")
            return
        }
        
        guard let filmRating = film.rating else {
            print("Has no rating")
            return
        }
        
        guard let filmLength = film.filmLength else {
            print("Has no length")
            return
        }
        
        guard let filmYear = film.year else {
            print("Has no year")
            return
        }
        guard let genres = film.genres, let filmGenre = genres[0].genre else {
            print("Has no genre")
            return
        }
        
        guard let url = film.posterUrl, let imageURL = URL(string: url) else {
            print("Invalid poster URL")
            return
        }
        
        posterURL.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "square.and.arrow.up"))
        genre.text = filmGenre
        title.text = name
        year.text = filmYear + ", "
        length.text = filmLength
        rating.text = filmRating
    }
    

}

// MARK: setting cell shadow and corner radius
extension AllMoviesTableViewCell {
    
    func setCellShadow() {
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 7
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    func setCellCornerRadius() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
    }
}


// MARK: adding views and constraints
extension AllMoviesTableViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(posterURL)
        contentView.addSubview(title)
        contentView.addSubview(genre)
        contentView.addSubview(year)
        contentView.addSubview(length)
        contentView.addSubview(rating)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

            posterURL.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterURL.heightAnchor.constraint(equalToConstant: 135),
            posterURL.widthAnchor.constraint(equalToConstant: 90),
            
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: posterURL.trailingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            

            year.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            year.leadingAnchor.constraint(equalTo: posterURL.trailingAnchor, constant: 20),
            
            
            genre.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            genre.leadingAnchor.constraint(equalTo: year.trailingAnchor, constant: 1),
            
            
            length.topAnchor.constraint(equalTo: genre.bottomAnchor, constant: 8),
            length.leadingAnchor.constraint(equalTo: posterURL.trailingAnchor, constant: 20),
            
            
            rating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)

        ])
    }
}
