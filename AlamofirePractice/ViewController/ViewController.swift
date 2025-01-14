//
//  ViewController.swift
//  AlamofirePractice
//
//  Created by BAE on 1/14/25.
//

import UIKit
import SnapKit
import Alamofire

final class ViewController: UIViewController, ViewConfig {

    lazy var btn1 = makeNavigateButton(to: .lotto)
    lazy var btn2 = makeNavigateButton(to: .moview)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHierarchy()
        configLayout()
        configView()
    }
    
    func configHierarchy() {
        view.addSubview(btn1)
        view.addSubview(btn2)
    }
    
    func configLayout() {
        btn1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.9)
        }
        
        btn2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.1)
        }
    }
    
    func configView() {
        view.backgroundColor = .white
    }

    func makeNavigateButton(to: Navigate) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = to.rawValue
    
        switch to {
        case .lotto:
            let vc = LottoViewController()
            AF.request("\(Urls.lotto)1154", method: .get).responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let value):
                    vc.fetchedData = value
                case .failure(let error):
                    print(error)
                }
            }
            
            let btn = UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
            return btn
            
        case .moview:
            let vc = MovieViewController()
            let btn = UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
            return btn
        }
        
    }
}

enum Navigate: String {
    case lotto = "로또뷰"
    case moview = "영화검색"
}
