//
//  NIGallaryCell.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit

class NIGallaryCell: UICollectionViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memeImageView: UIImageView!
    @IBOutlet private weak var detailHolderView: UIView!
    @IBOutlet private weak var infoHolderView: UIView!
    @IBOutlet private weak var infoHolderViewHeightConstraint: NSLayoutConstraint!
    
    /// Info Views
    @IBOutlet private weak var upVoteView: UIView!
    @IBOutlet private weak var upVoteImageView: UIImageView!
    @IBOutlet private weak var upVoteCountLabel: UILabel!
    @IBOutlet private weak var downVoteView: UIView!
    @IBOutlet private weak var downVoteCountLabel: UILabel!
    @IBOutlet private weak var viewsView: UIView!
    @IBOutlet private weak var viewsCountLabel: UILabel!
    @IBOutlet private weak var commentsView: UIView!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    
    //MARK:- Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        NIViewEffects.setShadowEffect(forView: self.shadowView, color: UIColor(hex: "#969696FF") ?? UIColor.clear)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.memeImageView.image = nil
    }
}

//MARK:- Config Cell
extension NIGallaryCell {
    func configCell(withGallaryMemeModel memeModel: NIGallaryMemeModel) {
        self.titleLabel.text = memeModel.title
        if let cover = memeModel.cover {
            let imageURLString = "https://i.imgur.com/\(cover).jpg"
            self.memeImageView.downloaded(from: imageURLString, contentMode: .scaleAspectFill) {(success) in
                //self?.updateColors()
            }
        }
        self.setInfoViewData(memeModel: memeModel)
    }
    
//    private func updateColors() {
//        DispatchQueue.main.async {
//            let colors = self.memeImageView.image?.getColors()
//            self.detailHolderView.backgroundColor = colors?.background.withAlphaComponent(0.60)
//            self.detailHolderView.isOpaque = false
//            self.upVoteCountLabel.textColor = colors?.primary
//            self.downVoteCountLabel.textColor = colors?.primary
//            self.viewsCountLabel.textColor = colors?.primary
//            self.commentsCountLabel.textColor = colors?.primary
//            self.titleLabel.textColor = colors?.primary
//        }
//    }
    
    private func setMemeInfo(memeModel: NIGallaryMemeModel) {
        if (self.isInfoViewNeedToHide(memeModel: memeModel)) {
            self.infoHolderView.isHidden = true
            self.infoHolderViewHeightConstraint.constant = 0
        } else {
            self.infoHolderView.isHidden = false
            self.infoHolderViewHeightConstraint.constant = 48
            self.setInfoViewData(memeModel: memeModel)
        }
    }
    
    private func setInfoViewData(memeModel: NIGallaryMemeModel) {
        self.setUpVoteData(upVoteCount: memeModel.ups)
        self.setDownVoteData(downVoteCount: memeModel.downs)
        self.setViewsData(viewsCount: memeModel.views)
        self.setCommentsData(commentsCount: memeModel.comment_count)
    }
    
    private func setUpVoteData(upVoteCount: Int?) {
        if let count = upVoteCount {
            self.upVoteView.isHidden = false
            self.upVoteCountLabel.text = "\(count)"
        } else {
            self.upVoteView.isHidden = true
        }
    }
    
    private func setDownVoteData(downVoteCount: Int?) {
        if let count = downVoteCount {
            self.downVoteView.isHidden = false
            self.downVoteCountLabel.text = "\(count)"
        } else {
            self.downVoteView.isHidden = true
        }
    }
    
    private func setViewsData(viewsCount: Int?) {
        if let count = viewsCount {
            self.viewsView.isHidden = false
            self.viewsCountLabel.text = "\(count)"
        } else {
            self.viewsView.isHidden = true
        }
    }
    
    private func setCommentsData(commentsCount: Int?) {
        if let count = commentsCount {
            self.commentsView.isHidden = false
            self.commentsCountLabel.text = "\(count)"
        } else {
            self.commentsView.isHidden = true
        }
    }
    
    private func isInfoViewNeedToHide(memeModel: NIGallaryMemeModel) -> Bool {
        return (memeModel.ups == nil &&
            memeModel.downs == nil &&
            memeModel.views == nil &&
            memeModel.comment_count == nil)
    }
}
