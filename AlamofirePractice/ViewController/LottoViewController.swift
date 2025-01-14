//
//  LottoViewController.swift
//  AlamofirePractice
//
//  Created by BAE on 1/14/25.
//

import UIKit
import Alamofire
import SnapKit
import Then

struct Lotto: Decodable {
    let drwNo: Int
    let drwNoDate: String
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
}


class LottoViewController: UIViewController, ViewConfig {
    
    private let notiLabel = UILabel()
    private let dateLabel = UILabel()
    private let lineView = UIView().then { $0.backgroundColor = .systemGray4 }
    private let resultLabel = UILabel()
    private let stackView = UIStackView()
    private let bnusLabel = UILabel()
    
    lazy var textField = UITextField()
    lazy var firstNo = makeCircledLabelView(text: fetchedData.drwtNo1, textColor: .white, bgColor: .systemYellow, size: ballSize)
    lazy var secondNo = makeCircledLabelView(text: fetchedData.drwtNo2, textColor: .white, bgColor: .systemYellow, size: ballSize)
    lazy var thirdNo = makeCircledLabelView(text: fetchedData.drwtNo3, textColor: .white, bgColor: .systemYellow, size: ballSize)
    lazy var fourthNo = makeCircledLabelView(text: fetchedData.drwtNo4, textColor: .white, bgColor: .systemYellow, size: ballSize)
    lazy var fifthNo = makeCircledLabelView(text: fetchedData.drwtNo5, textColor: .white, bgColor: .systemYellow, size: ballSize)
    lazy var sixthNo = makeCircledLabelView(text: fetchedData.drwtNo6, textColor: .white, bgColor: .systemYellow, size: ballSize)
    lazy var plusLabel = makeCircledLabelView(text: "+", textColor: .black, bgColor: .clear, size: ballSize)
    lazy var bnusNo = makeCircledLabelView(text: fetchedData.bnusNo, textColor: .white, bgColor: .systemYellow, size: ballSize)
    
    let spacing = 4
    
    var ballSize: Int {
        (Int(UIScreen.main.bounds.width) - spacing * 7 - 24) / 8
    }
    
    var _lotto: Lotto? {
        didSet {
            print(_lotto?.drwNoDate)
        }
    }
    
    var fetchedData: Lotto {
        get {
            guard let _lotto else {
                print("lotto 정보가 초기화 되지 않음")
                return Lotto(drwNo: 0, drwNoDate: "0", drwtNo1: 0, drwtNo2: 0, drwtNo3: 0, drwtNo4: 0, drwtNo5: 0, drwtNo6: 0, bnusNo: 0)
            }
            return _lotto
        }
        set(value) {
            _lotto = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLotto(drwNo: 1154)
        configHierarchy()
        configLayout()
        configView()
//        print(ballSize)
//        print(bnusLabel.subviews[0])
        print(#function, fetchedData)
    }

    func configView() {
        view.backgroundColor = .white
        
        textField.do {
            $0.textAlignment = .center
            $0.placeholder = "회차를 선택해주세요."
            $0.borderStyle = .roundedRect
        }
        
        notiLabel.do {
            $0.text = "당첨번호 안내"
            $0.font = .systemFont(ofSize: 14)
        }
        
        dateLabel.do {
            $0.text = fetchedData.drwNoDate
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 11)
        }
        
        resultLabel.do {
            let attributedText = NSMutableAttributedString(
                string: "\(fetchedData.drwNo)회 당첨결과",
                attributes: [
                    .font : UIFont.systemFont(ofSize: 24),
                ]
            )
        
            attributedText.addAttributes([
                .foregroundColor : UIColor.systemYellow
            ], range: NSRange(location: 0, length: 5)
            )
            
            $0.attributedText = attributedText
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
            $0.distribution = .fill
        }
        
        bnusLabel.do {
            $0.text = "보너스"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12)
        }
        
        print(#function)
        
        
        
//        if bnusLabel.subviews[0] is UILabel {
//            let label = bnusLabel.subviews[0] as! UILabel
//            label.textColor = .black
//        }
    }
    
    func configLayout() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        notiLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(12)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(notiLabel)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(notiLabel.snp.bottom).offset(12)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(12)
            $0.height.equalTo(ballSize)
        }
        
        bnusLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.centerX.equalTo(bnusNo.snp.centerX)
        }
        
        
        firstNo.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        secondNo.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        thirdNo.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        fourthNo.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        fifthNo.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        sixthNo.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        plusLabel.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        bnusNo.snp.makeConstraints {
            $0.size.equalTo(ballSize)
        }
        
    }
    
    func configHierarchy() {
        [textField, notiLabel, dateLabel, lineView, resultLabel, stackView, bnusLabel].forEach { view.addSubview($0) }
        [firstNo, secondNo, thirdNo, fourthNo, fifthNo, sixthNo, plusLabel, bnusNo].forEach { stackView.addArrangedSubview($0) }
    }
    
    func fetchLotto(drwNo: Int) {
        print(#function)
        AF.request("\(Urls.lotto)\(drwNo)", method: .get).responseDecodable(of: Lotto.self) { response in
//            print(value)
            
            switch response.result {
            case .success(let value):
                self.fetchedData = value
                
                print("fetched Data")
            case .failure(let error):
                print(error)
            }
            
        }

    }
    
    func makeCircledLabelView(text: String, textColor: UIColor, bgColor: UIColor, size: Int) -> UIView {
        print(#function)
        let size = CGFloat(size)
        let view = UIView().then {
            $0.backgroundColor = bgColor
            $0.frame = CGRect(x: 0, y: 0, width: size, height: size)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = size / 2
        }
        
        let label = UILabel().then {
            $0.text = text
            $0.textColor = textColor
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: size/2)
        }
        view.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview() }
        return view
    }
    
    func makeCircledLabelView(text: Int, textColor: UIColor, bgColor: UIColor, size: Int) -> UIView {
        print(#function)
        let size = CGFloat(size)
        let view = UIView().then {
            $0.backgroundColor = bgColor
            $0.frame = CGRect(x: 0, y: 0, width: size, height: size)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = size / 2
        }
        
        let label = UILabel().then {
            $0.text = "\(text)"
            $0.textColor = textColor
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: size/2)
        }
        view.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview() }
        return view
    }
}


final class lottoNumberView: UIView {
    
    private let label = UILabel().then {
        $0.font = .systemFont(ofSize: CGFloat(UIScreen.ballSize / 2))
        $0.textAlignment = .center
    }
    
    init(no: Int) {
        super.init(frame: .zero)
        configView()
        label.text = "\(no)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        self.backgroundColor = .systemBrown
        self.addSubview(label)
        self.clipsToBounds = true
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.ballSize, height: UIScreen.ballSize)
        self.layer.cornerRadius = CGFloat(UIScreen.ballSize / 2)
    }
    
    public func config(lottoNo: Int) {
        label.text = "\(lottoNo)"
        label.textColor = .white
    }
    public func config(lottoNo: String) {
        label.text = lottoNo
        label.textColor = .black
    }
}
