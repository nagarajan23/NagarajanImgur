//
//  NIViewEffects.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation
import UIKit

class NIViewEffects {
    static func setShadowEffectAtBottom(forView view:UIView, color:UIColor) {
        // Drop Shadow
        view.layer.shadowColor = color.cgColor;
        view.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        view.layer.shadowRadius = 2.0;
        view.layer.shadowOpacity = 0.3;
    }
    
    static func setShadowEffect(forView view: UIView, color: UIColor) {
        view.layer.masksToBounds = false;
        view.layer.shadowOffset = CGSize(width: 2, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = color.cgColor
    }
}
