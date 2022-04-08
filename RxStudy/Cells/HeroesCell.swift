//
//  HeroesCell.swift
//  RxStudy
//
//  Created by Adam Cseke on 2022. 04. 06..
//

import PaddingLabel
import SnapKit
import UIKit
import SDWebImage

class HeroesCell: UICollectionViewCell {
    
    private var heroNameLabel: PaddingLabel!
    private var heroDescriptionLabel: PaddingLabel!
    private var cellBackgroundImageView: UIImageView!
    
    // The card view that we apply transforms on
    var card: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        card = UIView()
        card.backgroundColor = .black
        card.layer.cornerRadius = 16
        card.layer.masksToBounds = true
        contentView.addSubview(card)
            
        card.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        configureCellBackgroundView()
        configureHeroNameLabel()
        configureHeroDescriptionLabel()
    }
    
    private func configureCellBackgroundView() {
        cellBackgroundImageView = UIImageView()
        cellBackgroundImageView.image = UIImage(named: "cellBackgroundImage")
        cellBackgroundImageView.contentMode = .scaleAspectFill
        cellBackgroundImageView.layer.cornerRadius = 24
        cellBackgroundImageView.layer.masksToBounds = true
        
        contentView.addSubview(cellBackgroundImageView)
        
        cellBackgroundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(contentView.frame.width / 2)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    private func configureHeroNameLabel() {
        heroNameLabel = PaddingLabel()
        heroNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        heroNameLabel.textColor = .orange
        heroNameLabel.textAlignment = .center
        heroNameLabel.layer.cornerRadius = 12
        heroNameLabel.layer.masksToBounds = true
        heroNameLabel.bottomInset = 5
        heroNameLabel.topInset = 5
        heroNameLabel.leftInset = 10
        heroNameLabel.rightInset = 10
        
        card.addSubview(heroNameLabel)
        
        heroNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cellBackgroundImageView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        
    }
    
    private func configureHeroDescriptionLabel() {
        heroDescriptionLabel = PaddingLabel()
        heroDescriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        heroDescriptionLabel.textColor = .orange.withAlphaComponent(0.7)
        heroDescriptionLabel.layer.cornerRadius = 12
        heroDescriptionLabel.layer.masksToBounds = true
        heroDescriptionLabel.bottomInset = 5
        heroDescriptionLabel.topInset = 5
        heroDescriptionLabel.leftInset = 10
        heroDescriptionLabel.rightInset = 10
        
        card.addSubview(heroDescriptionLabel)
        
        heroDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(heroNameLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func bind(name: String, description: String, imageURL: String) {
        heroNameLabel.text = name
        heroDescriptionLabel.text = "Full name: \(description)"
        cellBackgroundImageView.sd_setImage(with: URL(string: imageURL))
    }
}
