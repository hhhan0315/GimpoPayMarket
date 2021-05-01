//
//  DetailViewController.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/05/01.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var cmpnm: UILabel!
    @IBOutlet weak var indutype: UILabel!
    @IBOutlet weak var address: UILabel!
    var rowdata: Row?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationTitle(title: "지역화폐\n가맹점 상세정보")
        cmpnm.text = rowdata?.cmpnmNM
        indutype.text = rowdata?.indutypeNM
        address.text = rowdata?.refineRoadnmAddr
    }
}
