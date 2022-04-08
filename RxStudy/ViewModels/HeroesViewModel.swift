//
//  HeroesViewModel.swift
//  RxStudy
//
//  Created by Adam Cseke on 2022. 04. 08..
//
import RxCocoa
import RxSwift
import UIKit

class HeroesViewModel {
    var searchedHeroes = BehaviorRelay<[Heroes]>(value: [])
    var name =  PublishRelay<String?>()
    let disposeBag = DisposeBag()
    let userDidTapSearch = PublishRelay<Void>()
    
    var superHeroName: String = ""
    
    init() {
        userDidTapSearch.subscribe(onNext: { _ in
            self.getHeroes()
            
        }).disposed(by: disposeBag)
        
        name.subscribe { text in
            self.superHeroName = text ?? ""
        }
        .disposed(by: disposeBag)
    }
    
    private func getHeroes() {
        let url = RestClient.Constants.baseUrl + "/search/\(superHeroName)/"
        let request: Single<Superheroes> = RestClient.shared.request(urlString: url)
        request.subscribe(onSuccess: { heroes in
            self.searchedHeroes.accept(heroes.results)
        }, onFailure: { error in
            print(error.localizedDescription)
        }, onDisposed: {
            print("Cool")
        }).disposed(by: disposeBag)
        
    }
}
