//
//  NIGallaryCollectionView.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit

protocol NIGallaryCollectionViewDelegate {
    func didPerformPullDownRefresh()
    func didSelected(memeModel: NIGallaryMemeModel)
}

class NIGallaryCollectionView: NICollectionView {
    
    //MARK:- Variables
    var memeModels:[NIGallaryMemeModel] = [NIGallaryMemeModel]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    var gallaryViewDelegate: NIGallaryCollectionViewDelegate?
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        self.addPullToRefresh = true
        self.layoutSetup()
    }
    
    //MARK:- Layout Setup
    private func layoutSetup() {
        if let layout = self.collectionViewLayout as? NIGallaryLayout {
            layout.delegate = self
        }
        self.contentInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    override func refreshCollectionViewOnPullDown() {
        super.refreshCollectionViewOnPullDown()
        self.gallaryViewDelegate?.didPerformPullDownRefresh()
    }
}

//MARK:- Delegates
//MARK: Collection View Flow Layout Delegates
extension NIGallaryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "NIGallaryCell", for: indexPath as IndexPath) as! NIGallaryCell
        if (self.isValidIndexPath(indexPath)) {
            cell.configCell(withGallaryMemeModel: self.memeModels[indexPath.item])
        }
        return cell
    }
}


extension NIGallaryCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.isValidIndexPath(indexPath)) {
            self.gallaryViewDelegate?.didSelected(memeModel: self.memeModels[indexPath.item])
        }
    }
}

//MARK: NIGallary Layout Delegate
extension NIGallaryCollectionView: NIGallaryLayoutDelegate {
    func collectionView(_ collectionView: NIGallaryCollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if (self.isValidIndexPath(indexPath)) {
            let memeModel = self.memeModels[indexPath.item]
            if let imageHeight = memeModel.cover_width {
                if (imageHeight > 400 && imageHeight < 600) {
                    return CGFloat(imageHeight/2)
                } else if (imageHeight > 600 && imageHeight < 1000) {
                    return CGFloat(imageHeight/3)
                } else {
                    return 300
                }
            }
        }
        return 300
    }
}
