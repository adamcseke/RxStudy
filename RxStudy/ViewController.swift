//
//  ViewController.swift
//  RxStudy
//
//  Created by Adam Cseke on 2022. 04. 06..
//
import RxCocoa
import RxSwift
import UIKit
import SnapKit

struct HeroesViewModel {
    var searchedHeroes = BehaviorRelay<[Heroes]>(value: [])
    var name: String = ""
    
    func getHeroes() {
        let url = RestClient.Constants.baseUrl + "/search/\(name)/"
        RestClient.shared.request(urlString: url).subscribe(onSuccess: { heroes in
            self.searchedHeroes.accept(heroes.results)
            print(heroes)
            print(url)
        }, onFailure: { error in
            print(error)
        }, onDisposed: {
            print("Cool")
        })
        
    }
}

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    private var gradientView: GradientView!
    private var heroesButton: UIButton!
    private var textfield: UITextField!
    private var filterTextfield: UITextField!
    private var viewModel = HeroesViewModel()
    private var collectionView: UICollectionView!
    private var allHeroes = [Heroes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientView()
        configureTextfield()
        configureFilterTextfield()
        setupCollectionView()
        bindCollectionViewData()
    }
    
    func bindCollectionViewData() {
        viewModel.searchedHeroes.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: HeroesCell.self)) {
            row, model, cell in
            cell.bind(name: model.name,description: model.biography.fullName, imageURL: model.image.url)
        }.disposed(by: bag)
        
        collectionView.rx.modelSelected(Heroes.self).bind { hero in
            print(hero.name)
        }.disposed(by: bag)
        
        viewModel.getHeroes()
    }
    
    private func filterHeroes() {
        if filterTextfield.text == "" {
            self.viewModel.searchedHeroes.accept(self.allHeroes)
        } else {
            self.allHeroes.append(contentsOf: self.viewModel.searchedHeroes.value)
            let heroes = [Heroes]()
            self.viewModel.searchedHeroes.accept(heroes)
            self.viewModel.searchedHeroes.accept(self.allHeroes.filter({ $0.name.lowercased().contains(self.filterTextfield.text?.lowercased() ?? "")}))
        }
    }
    
    @objc private func getHeroes() {
        if textfield.text?.count == 0 {
            return
        } else {
            viewModel.name = textfield.text ?? ""
            viewModel.getHeroes()
            textfield.text = ""
        }
    }
    
    private func setupCollectionView() {
        let width =  view.bounds.width
        let availableWidth = width - 20
        let itemWidth = availableWidth
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 12, bottom: 12, right: 12)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 25)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HeroesCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        gradientView.addSubview(collectionView)
        
        
        collectionView.snp.makeConstraints { make in
            make.leading.centerX.equalToSuperview()
            make.top.equalTo(filterTextfield.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    private func configureTextfield() {
        textfield = UITextField()
        textfield.delegate = self
        textfield.returnKeyType = .search
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 3
        textfield.placeholder = "Search for a hero..."
        textfield.layer.cornerRadius = 16
        textfield.layer.masksToBounds = true
        textfield.textAlignment = .center
        textfield.addTarget(self, action: #selector(getHeroes), for: .editingDidEndOnExit)
        
        gradientView.addSubview(textfield)
        
        textfield.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(62)
            make.leading.equalTo(31)
            make.centerX.equalToSuperview()
        })
    }
    
    private func configureGradientView() {
        gradientView = GradientView()
        gradientView.colors = [UIColor.systemOrange, UIColor.systemOrange, UIColor.black]
        view.addSubview(gradientView)
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureFilterTextfield() {
        filterTextfield = UITextField()
        filterTextfield.delegate = self
        filterTextfield.returnKeyType = .search
        filterTextfield.autocapitalizationType = .none
        filterTextfield.autocorrectionType = .no
        filterTextfield.layer.borderColor = UIColor.black.cgColor
        filterTextfield.layer.borderWidth = 3
        filterTextfield.layer.cornerRadius = 16
        filterTextfield.layer.masksToBounds = true
        filterTextfield.textAlignment = .center
        filterTextfield.placeholder = "Filter the heroes..."
        filterTextfield.addTarget(self, action: #selector(filteringHeroes), for: .editingDidEndOnExit)
        
        gradientView.addSubview(filterTextfield)
        
        filterTextfield.snp.makeConstraints({ make in
            make.top.equalTo(textfield.snp.bottom).offset(10)
            make.height.equalTo(62)
            make.leading.equalTo(31)
            make.centerX.equalToSuperview()
        })
    }
    
    @objc private func filteringHeroes() {
        filterHeroes()
    }
}

extension ViewController: UITextFieldDelegate {
}
