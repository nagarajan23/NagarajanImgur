//
//  NILoadingAnimation.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit
import Lottie

class NILoadingAnimation: UIView {
    //MARK:- Properties
    //MARK: Variables
    var animationView: AnimationView?
    //MARK: Constants
    let animationViewWidth: CGFloat = 160
    let animationViewHeight: CGFloat = 160
    
    //MARK:- Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.isOpaque = false
        self.loadAnimationView()
    }
    
    convenience init(view: UIView) {
        self.init(frame: view.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK:- Load Animation View
private extension NILoadingAnimation {
    func loadAnimationView() {
        if(animationView != nil)
        {
            animationView!.removeFromSuperview()
        }
        self.initializeAnimationView()
        animationView!.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
    }
    
    func initializeAnimationView() {
        animationView = AnimationView()
        animationView!.translatesAutoresizingMaskIntoConstraints = false
        animationView!.backgroundColor = UIColor.clear
        
        let animation = Animation.named("LoadingCircleAnimation")
        animationView!.animation = animation
        
        animationView!.contentMode = .scaleAspectFill
        animationView!.backgroundBehavior = .pauseAndRestore
        self.addSubview(animationView!)
        animationView!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        animationView!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        animationView!.widthAnchor.constraint(equalToConstant: animationViewWidth).isActive = true
        animationView!.heightAnchor.constraint(equalToConstant: animationViewHeight).isActive = true
    }
    
    func hideAnimationView() {
        if let aView = self.animationView {
            aView.stop()
            aView.removeFromSuperview()
        }
    }
}

//MARK:- Indicator View Private Method
private extension NILoadingAnimation {
    static func loadingIndicator(forView view:UIView) -> NILoadingAnimation? {
        let subViews:[UIView] = view.subviews.reversed()
        var view:NILoadingAnimation?
        for subView in subViews {
            if subView is NILoadingAnimation {
                view = subView as? NILoadingAnimation
            }
        }
        return view
    }
    
    static func allLoadingIndicator(forView view:UIView) -> [NILoadingAnimation] {
        var indicators:[NILoadingAnimation] = [NILoadingAnimation]()
        let subViews:[UIView] = view.subviews.reversed()
        for subView in subViews {
            if subView is NILoadingAnimation {
                if let view = subView as? NILoadingAnimation {
                    indicators.append(view)
                }
            }
        }
        return indicators
    }
}

//MARK:- Hide/Show Loading Indicator
extension NILoadingAnimation {
    static func show(view: UIView) {
        if loadingIndicator(forView: view) == nil {
            let indicator = NILoadingAnimation.init(view: view)
            DispatchQueue.main.async {
                view.addSubview(indicator)
            }
        }
    }
    
    static func hide(view: UIView) {
        if let indicatorView = loadingIndicator(forView: view) {
            DispatchQueue.main.async {
                indicatorView.hideAnimationView()
                indicatorView.removeFromSuperview()
            }
        }
    }
    
    static func hideAll(view: UIView) {
        for indicatorView in allLoadingIndicator(forView: view) {
            DispatchQueue.main.async {
                indicatorView.hideAnimationView()
                indicatorView.removeFromSuperview()
            }
        }
    }
}

