//
//  TestCell.swift
//  RxStudy
//
//  Created by Adam Cseke on 2022. 04. 06..
//

import UIKit
import SnapKit
import SDWebImage

class FollowerCell: UICollectionViewCell {
    static var reuseIdentifier = "searchCell"
    
    private var shadowView: ShadowView!
    private var userImageView: UIImageView!
    private var userTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        configureShadowView()
        configureUserImageView()
        configureUserTitleLabel()
    }
    
    private func configureShadowView() {
        shadowView = ShadowView()
        
        contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.height.equalTo(shadowView.snp.width)
        }
    }
    
    private func configureUserImageView() {
        
        userImageView = UIImageView()
        userImageView.layer.cornerRadius = 12
        userImageView.clipsToBounds = true
        
        shadowView.addSubview(userImageView)
        
        userImageView.snp.makeConstraints({ make in
            make.centerX.equalTo(shadowView.snp.centerX)
            make.centerY.equalTo(shadowView.snp.centerY)
            make.height.width.equalTo(shadowView.snp.width)
        })
    }
    
    private func configureUserTitleLabel() {
        userTitleLabel = UILabel()
        userTitleLabel.textAlignment = .center
        userTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        userTitleLabel.textColor = .orange
        addSubview(userTitleLabel)
        
        userTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(13)
            make.leading.equalTo(8)
            make.centerX.equalToSuperview()
        }
    }
    
    func set(userImageUrl: String, userTitle: String) {
        
        userImageView.sd_setImage(with: URL(string: userImageUrl))
        userTitleLabel.text = userTitle
    }
    
    
    
}
