//
//  NICollectionView.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 20/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit

class NICollectionView: UICollectionView {
    
    //MARK:- Properties
    var addPullToRefresh: Bool = false {
        didSet {
            if (self.addPullToRefresh) {
                self.addPullDownRefreshControl()
            }
        }
    }
    
    //MARK:- Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- Refresh Control Selector
    func refreshCollectionViewOnPullDown() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull Down to Refresh")
    }
    
}

//MARK:- Pull Down Refresh
private extension NICollectionView {
    func addPullDownRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull Down to Refresh")
        refreshControl.tintColor = UIColor(hex: "#458756FF")
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc private func refreshCollectionView() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Leave to Refresh")
        self.refreshControl?.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshCollectionViewOnPullDown()
        }
    }
}

//MARK:- Valid Index Path
extension NICollectionView {
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let item = indexPath.item
        return (section < self.numberOfSections && item < self.numberOfItems(inSection: section))
    }
}
