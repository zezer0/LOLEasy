//
//  SummonerSearchViewController.swift
//  LOLEasy
//
//  Created by 재영신 on 2022/01/25.
//

import RxCocoa
import SnapKit
import RxSwift
import UIKit
import RxGesture

final class SummonerSearchViewController: BaseViewController {
    private lazy var topColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        return view
    }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Banner")
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 32.0
        textField.placeholder = "소환사 닉네임을 입력해주세요."
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15.0, height: textField.frame.height))
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "sparkle.magnifyingglass"), for: .normal)
        button.tintColor = UIColor.mainColor
        return button
    }()
    
    private lazy var registerSummonerView: UIView = {
        let view = UIView()
        [
            self.registerSummonerLabel,
            self.registerSummonerImageView
        ].forEach {
            view.addSubview($0)
        }
        
        return view
    }()
    
    private lazy var registerSummonerLabel: UILabel = {
        let label = UILabel()
        label.text = "본인의 아이디를 등록해주세요."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var registerSummonerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var summonerCardView: SummonerCardView = {
        let cardView = SummonerCardView()
        //cardView.isHidden = true
        cardView.layer.cornerRadius = 16.0
        return cardView
    }()
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        item.tintColor = .mainColor
        return item
    }()
    
    var viewModel: SummonerSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setLineDot(view: self.registerSummonerView, radius: 16.0)
    }
    
    override func configureUI() {
        [
            self.topColorView,
            self.titleImageView,
            self.searchTextField,
            self.searchButton,
            self.registerSummonerView,
            self.summonerCardView
        ].forEach { self.view.addSubview($0) }
        
        self.navigationItem.backBarButtonItem = self.backBarButtonItem
        
        self.topColorView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.view.frame.height / 3.0)
        }
        self.titleImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.centerY.equalTo(self.topColorView)
            make.height.equalTo(100.0)
        }
        
        self.searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(self.topColorView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(60.0)
        }
        
        self.searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.searchTextField)
            make.trailing.equalTo(self.searchTextField).offset(-16.0)
        }
        
        self.registerSummonerView.snp.makeConstraints { make in
            make.height.equalTo(200.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(self.searchTextField.snp.bottom).offset(48.0)
        }
        
        self.registerSummonerLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        self.registerSummonerImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40.0)
            make.center.equalToSuperview()
        }
        
        self.summonerCardView.snp.makeConstraints { make in
            make.edges.equalTo(self.registerSummonerView)
        }
    }
    
    override func bind() {
        
        let input = SummonerSearchViewModel.Input(
            viewDidLoad: Observable.empty(),
            didTapRegisterSummonerView: self.registerSummonerView.rx.tapGesture()
                .when(.recognized)
                .mapToVoid(),
            viewWillAppear: self.rx.sentMessage(#selector(self.viewWillAppear(_:))).mapToVoid(),
            didTapUnRegisterButton: self.summonerCardView.unRegisterButton.rx.tap.asObservable().mapToVoid(),
            didTapSearchButton: self.searchButton.rx.tap
                .withLatestFrom(self.searchTextField.rx.text)
                .compactMap{ $0 }
                .filter{ !$0.isEmpty }
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.showRegisterView
            .emit()
            .disposed(by: self.disposeBag)
        
        output.summonerInfo
            .do(onNext: {
                [weak self] _ in
                self?.registerSummonerView.isHidden = true
            })
                .drive(self.summonerCardView.rx.summonerInfo)
                .disposed(by: self.disposeBag)
                
                output.unRegister
                .emit(onNext: {
                    [weak self] _ in
                    self?.registerSummonerView.isHidden = false
                    self?.summonerCardView.isHidden = true
                })
                .disposed(by: self.disposeBag)
                output.searchSummoner
                .emit()
                .disposed(by: self.disposeBag)
                }
}


private extension SummonerSearchViewController {
    func setLineDot(view: UIView, radius: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = view.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.frame,  cornerRadius: radius).cgPath
        view.layer.addSublayer(borderLayer)
    }
    
    
}



import SwiftUI
struct SummonerSearchViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = SummonerSearchViewController() //보고 싶은 뷰컨 객체
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}


