//
//  ViewController.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/04/14.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var buttons = [UIButton]()
    private var rowData = [Row]()
    private let cellIdentifier = "marketTableCell"
    private var pIndex = 1
    private var isPaging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setNavigationTitle()
        setStackViewInScrollView()
        requestNetwork(pIndex: self.pIndex)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setNavigationTitle() {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        let attributedString = NSMutableAttributedString(string: "김포페이\n가맹점 찾기")
        let stringLength = attributedString.length
        
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .light)], range: NSRange(location: 0, length: 4))
        
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: NSRange(location: 5, length: stringLength-5))
        
        label.attributedText = attributedString
        
        self.navigationItem.titleView = label
    }
    
    func setStackViewInScrollView() {
        // storyboard 오류 수정을 위해 button 임의로 추가해둔 것 삭제
        removeAllSubViews()
        
        let titles = ["내 주변", "병원/약국", "슈퍼/마트", "스포츠/헬스", "미용/뷰티/위생", "레저", "학원/교육", "부동산/인테리어", "숙박/캠핑", "도서/문화/공연", "시장/거리", "전통시장/상점가", "일반음식점", "분식", "카페/베이커리", "산모/육아", "의류/잡화/안경", "자동차/자전거", "주유소", "가전/통신", "로컬친환경", "기타"]
        var buttonTag = 0
        
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 15
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            button.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
            button.tag = buttonTag
            buttonTag += 1
            
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
    }
    
    func removeAllSubViews() {
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    @objc func touchUpButton(_ sender:UIButton) {
        for button in buttons {
            if button.tag == sender.tag {
                button.backgroundColor = .gray
                button.setTitleColor(.white, for: .normal)
                guard let text = button.titleLabel?.text else {
                    return
                }
                descLabel.text = "\(text)에 해당하는 개의 가맹점이 있습니다."
                descLabel.font = UIFont.systemFont(ofSize: 14)
            } else {
                button.backgroundColor = .none
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    func requestNetwork(pIndex: Int) {
        let address = "https://openapi.gg.go.kr/RegionMnyFacltStus?Key=de4b73c6088a40aa9b532293ebdcad12&Type=json&SIGUN_CD=41570&pIndex=\(pIndex)&pSize=4"
        self.isPaging = true
        Network.requestAPI(address: address)
        
        // 관찰자 수신 완료, 처리하겠음 의 의미
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveDataNotification(_:)), name: DidReceiveDataNotification, object: nil)
    }
    
    @objc func didReceiveDataNotification(_ noti: Notification) {
        guard let data: [RegionMnyFacltStus] = noti.userInfo?["data"] as? [RegionMnyFacltStus] else {
            print("no data")
            return
        }
        
        guard let rowData = data.last?.row else {
            print("no row data")
            return
        }
        
        for data in rowData {
            self.rowData.append(data)
        }
        
        print("data receive success")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.isPaging = false
        }
        NotificationCenter.default.removeObserver(self, name: DidReceiveDataNotification, object: nil)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MarketTableViewCell else {
            return UITableViewCell()
        }
        
        let data = rowData[indexPath.row]
        
        cell.title.text = data.cmpnmNM
        cell.subTitle.text = data.refineRoadnmAddr
        
        return cell
    }
    
}

extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if position > contentHeight - frameHeight + 50 {
            if self.isPaging == false {
                self.pIndex += 1
                requestNetwork(pIndex: self.pIndex)
            }
        }
    }
}
