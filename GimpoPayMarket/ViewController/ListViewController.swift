//
//  ListViewController.swift
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
    private var filteredRowData = [Row]()
    private let sigunNames = ["김포시"]
    private let cellIdentifier = "marketTableCell"
    private var sigunName = ""
    private var pIndex = 1
    private var isPaging = false
    private var previousTag = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setNavigationTitle()
        setStackViewInScrollView()
        setSearchController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setStackViewInScrollView() {
        // storyboard 오류 수정을 위해 button 임의로 추가해둔 것 삭제
        removeAllSubViews()
        
        let titles = ["지역", "병원/약국", "슈퍼/마트", "스포츠/헬스", "미용/뷰티/위생", "레저", "학원/교육", "부동산/인테리어", "숙박/캠핑", "도서/문화/공연", "시장/거리", "전통시장/상점가", "일반음식점", "분식", "카페/베이커리", "산모/육아", "의류/잡화/안경", "자동차/자전거", "주유소", "가전/통신", "로컬친환경", "기타"]
        var buttonTag = 1
        
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
    
    private func removeAllSubViews() {
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    @objc func touchUpButton(_ sender:UIButton) {
        guard previousTag != sender.tag else {
            sender.backgroundColor = .none
            sender.setTitleColor(.black, for: .normal)
            previousTag = 0
            descLabel.text = self.sigunName == "" ? "지역을 선택해주세요" : "\(self.sigunName)를 선택했습니다."
            return
        }
        for button in buttons {
            if button.tag == sender.tag {
                button.backgroundColor = .gray
                button.setTitleColor(.white, for: .normal)
                guard let text = button.titleLabel?.text else {
                    return
                }
                descLabel.text = "\(text)에 해당하는 개의 가맹점이 있습니다."
                descLabel.font = UIFont.systemFont(ofSize: 14)
                previousTag = button.tag
            } else {
                button.backgroundColor = .none
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    private func requestNetwork(pIndex: Int, sigunName: String) {
        let key = "de4b73c6088a40aa9b532293ebdcad12"
        let pSize = 10
        let address = "https://openapi.gg.go.kr/RegionMnyFacltStus?Key=\(key)&Type=json&SIGUN_NM=\(sigunName)&pIndex=\(pIndex)&pSize=\(pSize)"
        
        isPaging = true
        Network.requestAPI(address: address)
        
        // 관찰자 수신 완료, 처리하겠음 의 의미
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveDataNotification(_:)), name: DidReceiveDataNotification, object: nil)
    }
    
    @objc func didReceiveDataNotification(_ noti: Notification) {
        guard let data: [RegionMnyFacltStus] = noti.userInfo?["data"] as? [RegionMnyFacltStus] else {
            print("no data")
            return
        }
        
        guard let totalCount = data.first?.head?.first?.listTotalCount else {
            print("no count")
            return
        }
        
        guard let dataRow = data.last?.row else {
            print("no row data")
            return
        }
        
        if UserSettings.shared.sigunName != self.sigunName {
            self.rowData.removeAll()
        }
        
        for data in dataRow {
            self.rowData.append(data)
        }

        print("data receive success")
        UserSettings.shared.totalCount = totalCount
        UserSettings.shared.sigunName = self.sigunName
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
            self.isPaging = false
        })
        
        NotificationCenter.default.removeObserver(self, name: DidReceiveDataNotification, object: nil)
    }
    
    private func makeActivityIndicator() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = footerView.center
        footerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return footerView
    }
    
    @IBAction func touchUpChooseRegion(_ sender: UIBarButtonItem) {
        self.sigunName = self.sigunNames.first ?? ""
        let alertController = UIAlertController(title: "지역 선택", message: nil, preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let contentView = UIViewController()
        contentView.view = pickerView
        contentView.preferredContentSize.height = 150
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
            if let button = self.view.viewWithTag(1) as? UIButton {
                button.setTitle(self.sigunName, for: .normal)
                self.descLabel.text = "\(self.sigunName)를 선택했습니다."
            }
            self.tableView.tableFooterView = self.makeActivityIndicator()
            self.requestNetwork(pIndex: self.pIndex, sigunName: self.sigunName)
        }))
        
        alertController.setValue(contentView, forKey: "contentViewController")
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func filterContentForSearchText(_ searchText: String) {
      filteredRowData = rowData.filter { (row: Row) -> Bool in
        if let cmpnmNM = row.cmpnmNM {
            return cmpnmNM.contains(searchText)
        }
        return false
      }

      tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.filteredRowData.count
        }
        return self.rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MarketTableViewCell else {
            return UITableViewCell()
        }
        let row: Row

        if isFiltering {
            row = filteredRowData[indexPath.row]
        } else {
            row = rowData[indexPath.row]
        }
        
        cell.title.text = row.cmpnmNM
        cell.subTitle.text = row.refineRoadnmAddr
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if position > contentHeight - frameHeight + 50 {
            if self.isPaging == false {
                self.tableView.tableFooterView = makeActivityIndicator()
                self.pIndex += 1
                requestNetwork(pIndex: self.pIndex, sigunName: self.sigunName)
            }
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDelegate
extension ListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sigunNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sigunNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sigunName = self.sigunNames[row]
    }
}

// MARK: - UISearchResultsUpdating
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchBarText = searchController.searchBar.text {
            filterContentForSearchText(searchBarText)
        }
    }
}
