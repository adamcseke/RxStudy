//
//  RestClient+Heroes.swift
//  RxStudy
//
//  Created by Adam Cseke on 2022. 04. 08..
//

import Foundation
import RxSwift

extension RestClient {
    
    func getHeroes(name: String) -> Single<Superheroes> {
        let url = RestClient.Constants.baseUrl + "/search/\(name)/"
        return request(urlString: url)
    }
}
