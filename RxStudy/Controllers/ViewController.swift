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

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private var gradientView: GradientView!
    private var heroesButton: UIButton!
    private var textfield: UITextField!
    private var filterTextfield: UITextField!
    private var viewModel: HeroesViewModel!
    private var collectionView: UICollectionView!
    private var allHeroes: [Heroes] = []
    private var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HeroesViewModel()
        configureGradientView()
        configureTextfield()
        configureFilterTextfield()
        configureSearchButton()
        setupCollectionView()
        bindCollectionViewData()
        
        driveToUI()
        bindToViewModel()
    }
    
    func driveToUI() {
        viewModel.searchedHeroes
            .asDriver()
            .drive { [weak self] _ in
                self?.getHeroes()
            }
            .disposed(by: disposeBag)
    }
    
    func bindToViewModel() {
        textfield.rx.text
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: viewModel.userDidTapSearch)
            .disposed(by: disposeBag)
    }
    
    func bindCollectionViewData() {
        viewModel.searchedHeroes.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: HeroesCell.self)) {
            row, model, cell in
            cell.bind(name: model.name,description: model.biography.fullName, imageURL: model.image.url)
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Heroes.self).bind { hero in
            print(hero.name)
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe { indexPath in
            print(indexPath)
        }.disposed(by: disposeBag)
        
    }
    
    private func filterHeroes() {
        if filterTextfield.text == "" {
        } else {
            self.allHeroes.append(contentsOf: self.viewModel.searchedHeroes.value)
            
            self.viewModel.searchedHeroes.value.forEach { hero in
                self.viewModel.searchedHeroes.accept(self.allHeroes.filter({ $0.name.lowercased().contains(self.filterTextfield.text?.lowercased() ?? "")}))
            }
        }
    }
    
    @objc private func getHeroes() {
        textfield.text = ""
        searchButton.isEnabled = false
        searchButton.backgroundColor = .systemOrange.withAlphaComponent(0.5)
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
            make.bottom.equalTo(searchButton.snp.top).offset(-10)
        }
        
    }
    
    private func configureTextfield() {
        textfield = UITextField()
        textfield.delegate = self
        textfield.returnKeyType = .done
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 3
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Search for a hero",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textfield.layer.cornerRadius = 16
        textfield.layer.masksToBounds = true
        textfield.textAlignment = .center
        
        gradientView.addSubview(textfield)
        
        textfield.snp.makeConstraints({ make in
            make.centerY.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(62)
            make.leading.equalTo(31)
            make.centerX.equalToSuperview()
        })
    }
    
    @objc private func dismissKeyboard() {
        
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
        filterTextfield.returnKeyType = .search
        filterTextfield.autocapitalizationType = .none
        filterTextfield.autocorrectionType = .no
        filterTextfield.layer.borderColor = UIColor.black.cgColor
        filterTextfield.layer.borderWidth = 3
        filterTextfield.layer.cornerRadius = 16
        filterTextfield.layer.masksToBounds = true
        filterTextfield.textAlignment = .center
        filterTextfield.attributedPlaceholder = NSAttributedString(
            string: "Filter the heroes",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
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
    
    private func configureSearchButton() {
        searchButton = UIButton()
        searchButton.layer.cornerRadius = 16
        searchButton.layer.masksToBounds = true
        searchButton.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        
        gradientView.addSubview(searchButton)
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.7)
            make.leading.equalToSuperview().offset(31)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let name = textField.text ?? ""
        
        if name.isEmpty {
            searchButton.isEnabled = false
            searchButton.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        } else {
            searchButton.isEnabled = true
            searchButton.backgroundColor = .systemOrange
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
