//
//  MovieViewController.swift
//  AlamofirePractice
//
//  Created by BAE on 1/14/25.
//

import UIKit
import Alamofire

class MovieViewController: UIViewController, ViewConfig {

    private let dim = UIView().then { $0.backgroundColor = .black.withAlphaComponent(0.9) }
    private let underline = UIView()
    private let textField = UITextField()
    private let tableView = UITableView()
    private let searchButton = UIButton()
    
    var _movieList: [MovieInfo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var movieList: [MovieInfo] {
        get {
            return _movieList
        }
        set {
            _movieList = newValue
        }
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configHierarchy()
        configLayout()
        configView()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        textField.addUnderLine(width: 4, color: .white)
//    }
    
    func configHierarchy() {
        [dim, underline, textField, searchButton, tableView].forEach { view.addSubview($0) }
    }
    
    func configLayout() {
        dim.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(12)
        }
        
        underline.snp.makeConstraints {
            $0.bottom.equalTo(textField.snp.bottom)
            $0.leading.trailing.equalTo(textField)
            $0.height.equalTo(2)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.top)
            $0.leading.equalTo(textField.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(100)
            $0.height.equalTo(textField)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(12)
            $0.leading.bottom.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configView() {
        textField.do {
            $0.textColor = .white
            $0.borderStyle = .none
        }
        
        searchButton.do {
            $0.setTitle("검색", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.addAction(UIAction(handler: { _ in
                if let text = self.textField.text {
                    if text.isEmpty {
                        print("공백")
                        self.showSimpleAlert(title: "공백 입력", message: "yyyyMMdd 형식으로 검색해주세요.", handler: nil)
                    } else {
                        self.fetchMovieList(when: text)
                        self.textField.text = ""
                    }
                } else {
                    print("텍스트 필드 nil")
                    self.showSimpleAlert(title: "입력 오류", message: "yyyyMMdd 형식으로 검색해주세요.") { _ in
                        self.textField.text = ""
                    }
                }
            }), for: .touchUpInside)
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = UIScreen.main.bounds.height / 20
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.register(MoodiLikeTableViewCell.self, forCellReuseIdentifier: MoodiLikeTableViewCell.identifier)
        }
        
        underline.do {
            $0.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
            $0.backgroundColor = .white
        }
    }
    
    func fetchMovieList(when: String) {
        AF.request("\(Urls.boxOffice)\(when)", method: .get).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                self.movieList = value.boxOfficeResult.dailyBoxOfficeList
                print(self.movieList)
            case .failure(let error):
                // TODO: Alamofire error 케이스 별로 처리하기
                print(error)
            }
        }
    }
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = movieList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MoodiLikeTableViewCell.identifier, for: indexPath) as! MoodiLikeTableViewCell
        
        cell.config(row: row)
        return cell
    }
}

extension MovieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if text.isEmpty {
                print("공백")
                self.showSimpleAlert(title: "공백 입력", message: "yyyyMMdd 형식으로 검색해주세요.", handler: nil)
                return false
            } else {
                self.fetchMovieList(when: text)
                self.textField.text = ""
                return true
            }
        } else {
            print("텍스트 필드 nil")
            self.showSimpleAlert(title: "입력 오류", message: "yyyyMMdd 형식으로 검색해주세요.") { _ in
                self.textField.text = ""
            }
            return false
        }
    }
    
}


final class MoodiLikeTableViewCell: UITableViewCell, ViewConfig {
    
    static let identifier = "MoodiLikeTableViewCell"
    
    private let rankLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configHierarchy()
        configLayout()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        [rankLabel, titleLabel, dateLabel].forEach { contentView.addSubview($0) }
    }
    
    func configLayout() {
        rankLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.height / 20 - 8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(dateLabel.snp.leading)
            $0.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(4)
        }
    }
    
    func configView() {
        contentView.backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        backgroundColor = .clear
        
        rankLabel.do {
            $0.font = .boldSystemFont(ofSize: 15)
            $0.textAlignment = .center
            $0.backgroundColor = .white
            
        }
        titleLabel.do {
            $0.font = .boldSystemFont(ofSize: 15)
            $0.backgroundColor = .clear
            $0.textColor = .white
            
        }
        dateLabel.do {
            $0.font = .systemFont(ofSize: 12)
            $0.backgroundColor = .clear
            $0.textColor = .white
            $0.setContentCompressionResistancePriority(.init(rawValue: 752), for: .horizontal)
            
        }
    }
    
    func config(row: MovieInfo){
        rankLabel.text = "\(row.rank)"
        titleLabel.text = row.movieNm
        dateLabel.text = row.openDt
    }
}

