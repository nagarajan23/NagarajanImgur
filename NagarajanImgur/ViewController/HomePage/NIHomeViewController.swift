//
//  NIHomeViewController.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit
import ShimmerSwift

class NIHomeViewController: NIViewController {

    //MARK:- Properties
    //MARK: Variables
    let taskHandler = NIHomePageTaskHandler()
    var fetchingShimmerView: ShimmeringView?
    
    //MARK: Outlets
    @IBOutlet private weak var gallaryCollectionView: NIGallaryCollectionView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var accountName: UILabel!
    @IBOutlet private weak var gallaryHolderView: UIView!
    
    //MARK:- Custom Initialization
    
    override func initializeOnViewDidLoad() {
        super.initializeOnViewDidLoad()
        self.addBottomShadowForNavigationBar()
        self.initializeCollectionViewProperties()
        self.initialieFetchingShimmerView()
        self.addTaskHandlerObservers()
        self.taskHandler.fetchData()
    }
    
    override func initializeOnViewWillAppear() {
        super.initializeOnViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

//MARK:- Initialize View Properties
private extension NIHomeViewController {
    func initializeCollectionViewProperties() {
        self.gallaryCollectionView.gallaryViewDelegate = self
    }
}

//MARK:- Shimmer View
private extension NIHomeViewController {
    func initialieFetchingShimmerView() {
        self.fetchingShimmerView = ShimmeringView(frame: self.gallaryHolderView.bounds)
        self.fetchingShimmerView!.isHidden = true
        self.fetchingShimmerView!.backgroundColor = UIColor(hex: "#F8F8F8FF")
        self.fetchingShimmerView!.shimmerAnimationOpacity = 0.0
        self.fetchingShimmerView!.shimmerSpeed = 250
        self.gallaryHolderView.addSubview(self.fetchingShimmerView!)
        if let fetchingLayoutView = self.loadNibFile(fileName: "NIGallaryFetchingShimmerView") as? UIView {
            fetchingLayoutView.backgroundColor = UIColor.white
            self.fetchingShimmerView!.contentView = fetchingLayoutView
        }
    }
    
    func showFethingShimmerView() {
        if(self.fetchingShimmerView != nil) {
            self.gallaryHolderView.bringSubviewToFront(self.fetchingShimmerView!)
            self.fetchingShimmerView!.isHidden = false
            self.fetchingShimmerView!.isShimmering = true
        }
    }
    
    func hideFetchingShimmerView() {
        if(self.fetchingShimmerView != nil) {
            self.fetchingShimmerView!.isHidden = true
            self.fetchingShimmerView!.isShimmering = false
            self.gallaryHolderView.sendSubviewToBack(self.fetchingShimmerView!)
        }
    }
}

//MARK:- TaskHandler Observers
extension NIHomeViewController {
    private func addTaskHandlerObservers() {
        self.taskHandler.memeModels.bind {[weak self] (memeModels) in
            self?.gallaryCollectionView.memeModels = memeModels
        }
        
        self.taskHandler.accountData.bind {[weak self] (accountData) in
            if let accountData = accountData {
                self?.updateAccountData(accountData: accountData)
            }
        }
        
        self.taskHandler.fetching.bind {[weak self] (fetching) in
            if let fetching = fetching {
                fetching ? self?.showFethingShimmerView() : self?.hideFetchingShimmerView()
            }
        }
        
        self.taskHandler.errorMessage.bind {[weak self] (errorMessage) in
            if let message = errorMessage, !message.isEmpty {
                self?.showErrorAlert(errorMessage: message)
            }
        }
    }
}

//MARK:- View Config
extension NIHomeViewController {
    private func updateAccountData(accountData: NIAccountData) {
        self.accountName.text = accountData.url
        self.avatarImageView.downloaded(from: accountData.avatar, contentMode: .scaleAspectFit)
    }
}

//MARK:- Button Action
extension NIHomeViewController {
    @IBAction func didProfileButtonPressed(_ sender: UIButton) {
        self.navigateToProfileViewController()
    }
}

//MARK:- Navigation
extension NIHomeViewController {
    private func navigateToProfileViewController() {
        if let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "NIProfileViewController") as? NIProfileViewController {
            profileVC.accountData = self.taskHandler.accountData.value
            self.navigateToViewController(controller: profileVC, animated: true)
        }
    }
}

//MARK:- Alert Controller
extension NIHomeViewController: NIAlertControllerProtocol {
    private func showErrorAlert(errorMessage: String) {
        self.showAlertController(withTitle: nil, message: errorMessage, acceptActionTitle: "OK", acceptActionBlock: nil, dismissActionTitle: nil, dismissActionBlock: nil)
    }
}

//MARK:- Delegates
//MARK: Gallary Collection View Delegate
extension NIHomeViewController: NIGallaryCollectionViewDelegate {
    func didPerformPullDownRefresh() {
        self.taskHandler.fetchDataOnPullDownRefresh()
    }
    
    func didSelected(memeModel: NIGallaryMemeModel) {
        
    }
}
