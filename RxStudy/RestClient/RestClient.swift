//
//  RestClient.swift
//  RxStudy
//
//  Created by Adam Cseke on 2022. 04. 06..
//

import RxSwift
import RxCocoa
import Foundation

final class RestClient {
    static let shared = RestClient()
    
    struct Constants {
        static let baseUrl = "https://superheroapi.com/api.php/" + apiKey
        static let apiKey = "2915390945376495"
    }
    
    private init() {}
    
    func request(urlString: String) -> Single<Superheroes> {
        return Single<Superheroes>.create { observer  in
            guard let url = URL(string: urlString) else {
                return Disposables.create()
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    let heroes: Superheroes = try JSONDecoder().decode(Superheroes.self, from: data ?? Data())
                    observer(.success(heroes))

                } catch let error {
                    observer(.failure(error))
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

