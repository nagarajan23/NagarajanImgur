//
//  NIProfileViewController.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit
import UIImageColors

class NIProfileViewController: NIViewController {
    
    //MARK:- Properties
    //MARK: Outlets
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var reputationCount: UILabel!
    @IBOutlet private weak var reputationType: UILabel!
    @IBOutlet private weak var activitiesView: UIView!
    
    //MARK: Variables
    var accountData: NIAccountData?
    

    //MARK:- Initialization
    override func initializeOnViewDidLoad() {
        super.initializeOnViewDidLoad()
        self.addBottomShadowForNavigationBar()
        self.configAccountData()
    }
}

//MARK:- View Config
private extension NIProfileViewController {
    func configAccountData() {
        if let accountData = self.accountData {
            self.userNameLabel.text = accountData.url
            self.reputationCount.text = "\(accountData.reputation) PTS"
            self.reputationType.text = accountData.reputation_name
            self.bannerImageView.downloaded(from: accountData.cover, contentMode: .scaleAspectFill) { (success) in
                if (success) {
                    let colors = self.bannerImageView.image?.getColors()
                    self.userNameLabel.textColor = colors?.primary
                    self.reputationCount.textColor = colors?.secondary
                    self.reputationType.textColor = colors?.detail
                }
            }
            self.avatarImageView.downloaded(from: accountData.avatar, contentMode: .scaleAspectFill) { (success) in
                if (success) {
                }
            }
        }
    }
}
