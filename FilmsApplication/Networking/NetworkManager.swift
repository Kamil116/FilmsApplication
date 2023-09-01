//
//  NetworkManager.swift
//  FilmsProject
//
//  Created by Тимур Жексимбаев on 17.07.2023.
//

import Foundation

protocol NetworkRequests {
    
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    // get all movies
    func getAllMovies(completion: @escaping ((Result<TopFilms, Error>) -> Void)) {
        for i in 1...12 {
            
            let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/top?type=TOP_250_BEST_FILMS" + "&page=" + String(i)
            
            guard let url = URL(string: urlString) else { return }
            
            var getRequest = URLRequest(url: url)
            
            getRequest.addValue("c7f141a1-fac1-4b6b-a2bc-482353a76479", forHTTPHeaderField: "X-API-KEY")
            
            URLSession.shared.dataTask(with: getRequest) { data, response, error in
                
                let resp = response as? HTTPURLResponse
                print(resp?.statusCode)

                if error == nil {
                    guard let data = data else { return }
                    do {
                        let similarMovies = try JSONDecoder().decode(TopFilms.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(similarMovies))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    guard let error = error else { return }
                    completion(.failure(error))
                }
            }.resume()
            
            if i % 5 == 0 {
                sleep(1)
            }
        }
    }
    
    // get top movies
    func getTopMovies(completion: @escaping ((Result<TopFilms, Error>) -> Void)) {
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/top?type=TOP_100_POPULAR_FILMS"
        
        guard let url = URL(string: urlString) else { return }
        
        var getRequest = URLRequest(url: url)
        
        getRequest.addValue("c7f141a1-fac1-4b6b-a2bc-482353a76479", forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: getRequest) { data, response, error in
            
            let resp = response as? HTTPURLResponse
            print(resp?.statusCode)

            if error == nil {
                guard let data = data else { return }
                do {
                    let similarMovies = try JSONDecoder().decode(TopFilms.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(similarMovies))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
        
    }
    
    // get similar movies
    func fetchSimilarMovies(idMovie: Int, completion: @escaping ((Result<MovieDetails, Error>) -> Void)) {
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(idMovie)"
        guard let url = URL(string: urlString) else { return }
        var getRequest = URLRequest(url: url)
        getRequest.addValue("c7f141a1-fac1-4b6b-a2bc-482353a76479", forHTTPHeaderField: "X-API-KEY")
        URLSession.shared.dataTask(with: getRequest) { data, _, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let similarMovies = try JSONDecoder().decode(MovieDetails.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(similarMovies))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func search(keyword: String, completion: @escaping ((Result<TopFilms, Error>) -> Void)) {
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(keyword)&page=1"
        guard let url = URL(string: urlString) else { return }
        var getRequest = URLRequest(url: url)
        getRequest.addValue("c7f141a1-fac1-4b6b-a2bc-482353a76479", forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: getRequest) { data, _, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let similarMovies = try JSONDecoder().decode(TopFilms.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(similarMovies))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}
