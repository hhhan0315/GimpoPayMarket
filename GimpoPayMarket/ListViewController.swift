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
    private var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle()
        setStackViewInScrollView()
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
    

}

