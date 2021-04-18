//
//  ViewController.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/04/14.
//

import UIKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle()
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

}

