//
//  RegisterSummonerViewController.swift
//  LOLEasy
//
//  Created by 재영신 on 2022/01/26.
//

import UIKit


final class RegisterSummonerViewController: BaseViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "본인의 소환사 이름을 입력하세요."
        label.font = .systemFont(ofSize: 32.0, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        textField.layer.cornerRadius = 32.0
        textField.placeholder = "소환사 이름"
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainColor
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16.0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            titleLabel,
            nameTextField,
            registerButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(64.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(32.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(100)
        }
        
        self.registerButton.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom).offset(32.0)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(80)
        }
        
    }
}

import SwiftUI
struct RegisterViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = RegisterSummonerViewController() //보고 싶은 뷰컨 객체
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
