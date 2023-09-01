//
//  LikedFilmsViewController.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 06.08.2023.
//

import UIKit
import CoreData

class LikedFilmsViewController: UIViewController {
    
    var likedFilms = [Film]()

    private var table: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(AllMoviesTableViewCell.self, forCellReuseIdentifier: "AllMoviesCell")
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        likedFilms = LikedFilmsDataController.shared.getFilms()
        table.reloadData()

        navigationItem.title = "Liked films"
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leftAnchor.constraint(equalTo: view.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedFilms = LikedFilmsDataController.shared.getFilms()
        table.reloadData()
    }
    
}

// MARK: setup table view
extension LikedFilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        likedFilms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllMoviesCell", for: indexPath) as? AllMoviesTableViewCell else {
            return UITableViewCell()
        }

        let film = likedFilms[indexPath.row]
        cell.configure(with: film)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellFilm = likedFilms[indexPath.row]
        let openCell = DetailViewController()
        openCell.configure(movie: cellFilm)
        navigationController?.pushViewController(openCell, animated: true)

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            LikedFilmsDataController.shared.deleteFilm(film: likedFilms[indexPath.row])
            likedFilms.remove(at: indexPath.row)
           tableView.beginUpdates()
           tableView.deleteRows(at: [indexPath], with: .automatic)
           tableView.endUpdates()
        }
    }

}

