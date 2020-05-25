//
//  LoadingIndicatorProtocol.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingIndicator where Self: UIViewController {
    func showLoadingIndicatorView()
    func hideLodingIndicatorView()
    func hideAllLoadingIndicatorView()
}

extension LoadingIndicator {
    func showLoadingIndicatorView() {
        NILoadingAnimation.show(view: self.view)
    }

    func hideLodingIndicatorView() {
        NILoadingAnimation.hide(view: self.view)
    }

    func hideAllLoadingIndicatorView() {
        NILoadingAnimation.hideAll(view: self.view)
    }
}
