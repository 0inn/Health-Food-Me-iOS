//
//  ExpandableInfoTVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/07.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class ExpandableInfoTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    var foldState: Bool = false
    let disposeBag = DisposeBag()
    let toggleButtonTapped = PublishRelay<Void>()
    let telePhoneLabelTapped = PublishRelay<String>()
    
    // MARK: - UI Components
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = ImageLiterals.MainDetail.locationIcon
        iv.isHidden = false
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "월요일 00:00 ~ 24:00"
        lb.textAlignment = .left
        lb.textColor = .helfmeGray1
        lb.font = .NotoMedium(size: 12)
        lb.numberOfLines = 0
        lb.sizeToFit()
        lb.isUserInteractionEnabled = true
        lb.lineBreakMode = .byClipping
        return lb
    }()
    
    private lazy var toggleButtonInfnoLabel: UIButton = {
        let bt = UIButton()
        bt.addAction(UIAction(handler: { _ in
            self.postObserverAction(.foldButtonClicked)
        }), for: .touchUpInside)
        bt.isHidden = false
        return bt
    }()
    
    private lazy var toggleButton: UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(ImageLiterals.MainDetail.showdownIcon, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            self.postObserverAction(.foldButtonClicked)
        }), for: .touchUpInside)
        return bt
    }()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        removeObserverAction(.foldButtonClicked)
    }
}

// MARK: - Methods

extension ExpandableInfoTVC {
    private func setUI() {
        self.contentView.backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        self.contentView.addSubviews(iconImageView, infoLabel, toggleButton, toggleButtonInfnoLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(4)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12.5)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(4)
        }
        
        toggleButtonInfnoLabel.snp.makeConstraints { make in
            make.center.equalTo(infoLabel.snp.center)
            make.width.equalTo(infoLabel.snp.width)
            make.height.equalTo(infoLabel.snp.height)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.leading.equalTo(infoLabel.snp.trailing).offset(2)
            make.centerY.equalTo(iconImageView).offset(2)
        }
    }
    
    func setFoldStateImage(isFolded: Bool) {
        if isFolded {
            toggleButton.setBackgroundImage(ImageLiterals.MainDetail.showdownIcon, for: .normal)
        } else {
            toggleButton.setBackgroundImage(ImageLiterals.MainDetail.showupIcon, for: .normal)
        }
    }
    
    func setUIWithIndex(indexPath: IndexPath, isOpenned: Bool, expandableData: MainDetailExpandableModel) {
        let isFirstRow = indexPath.row == 0
        let isSecondSection = indexPath.section == 1
        
        switch indexPath.section {
        case 0:
            iconImageView.image = ImageLiterals.MainDetail.locationIcon
            infoLabel.text = expandableData.location
                toggleButtonInfnoLabel.isHidden = true
        case 1:
            iconImageView.image = ImageLiterals.MainDetail.timeIcon
            toggleButton.isHidden = !expandableData.isExpandable
                print("@@#@#@",expandableData.labelText)
            if expandableData.labelText.count > 0 {
                print("2")

                var result = ""
                for line in expandableData.labelText {
                    result += line
                    result += "\n"
                }
                infoLabel.text = result
                infoLabel.sizeToFit()
                toggleButton.isHidden = false
                toggleButtonInfnoLabel.isHidden = false
                toggleButtonInfnoLabel.isEnabled = true
                toggleButton.isEnabled = true


            } else {
                toggleButton.isHidden = true
                toggleButton.isEnabled = false
                toggleButton.setBackgroundImage(UIImage(), for: .disabled)
                toggleButton.setImage(UIImage(), for: .disabled)
                toggleButtonInfnoLabel.isHidden = true
                toggleButtonInfnoLabel.isEnabled = false
                infoLabel.text = "영업시간 정보 없음"

                infoLabel.sizeToFit()
            }

        default:
            iconImageView.image = ImageLiterals.MainDetail.phoneIcon
            let telephoneString = expandableData.telephone
            let attributeString = NSMutableAttributedString(string: telephoneString)
            attributeString.addAttribute(.underlineStyle, value: 1, range: NSRange.init(location: 0, length: telephoneString.count))
            infoLabel.attributedText = attributeString
                toggleButtonInfnoLabel.isHidden = true
            setTapGesture()
        }
        
        iconImageView.isHidden = !isFirstRow
        toggleButton.isHidden = !(isFirstRow && isSecondSection)
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentTelephoneApp))
        infoLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func presentTelephoneApp() {
        if let text = infoLabel.text {
            telePhoneLabelTapped.accept(text)
        }
    }
}
