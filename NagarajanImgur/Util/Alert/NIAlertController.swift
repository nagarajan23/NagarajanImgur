//
//  NIAlertController.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 20/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation
import UIKit

typealias NIAlertActionBlock = ((_ action: UIAlertAction) -> Void)?

protocol NIAlertControllerProtocol where Self: UIViewController {
    func showAlertController(withTitle title: String?, message: String?, acceptActionTitle: String?, acceptActionBlock: NIAlertActionBlock, dismissActionTitle: String?, dismissActionBlock: NIAlertActionBlock)
}

extension NIAlertControllerProtocol {
    func showAlertController(withTitle title: String?, message: String?, acceptActionTitle: String?, acceptActionBlock: NIAlertActionBlock, dismissActionTitle: String?, dismissActionBlock: NIAlertActionBlock) {
        NIAlertController.showAlert(withTitle: title, message: message, acceptActionTitle: acceptActionTitle, acceptActionBlock: acceptActionBlock, dismissActionTitle: dismissActionTitle, dismissActionBlock: dismissActionBlock, viewController: self)
    }
}

class NIAlertController {
    static func showAlert(withTitle title: String?, message: String?, acceptActionTitle: String?, acceptActionBlock: NIAlertActionBlock, dismissActionTitle: String?, dismissActionBlock: NIAlertActionBlock, viewController: UIViewController?) {
        if let topmostViewController = self.getTopmostViewController(), let presendedController = topmostViewController.presentedViewController, presendedController.isKind(of: UIAlertController.self) {
            presendedController.dismiss(animated: true) {
                self.presentAlert(withTitle: title, message: message, acceptActionTitle: acceptActionTitle, acceptActionBlock: acceptActionBlock, dismissActionTitle: dismissActionTitle, dismissActionBlock: dismissActionBlock, viewController: viewController)
            }
        } else {
            self.presentAlert(withTitle: title, message: message, acceptActionTitle: acceptActionTitle, acceptActionBlock: acceptActionBlock, dismissActionTitle: dismissActionTitle, dismissActionBlock: dismissActionBlock, viewController: viewController)
        }
    }
    
    private static func presentAlert(withTitle title: String?, message: String?, acceptActionTitle: String?, acceptActionBlock: NIAlertActionBlock, dismissActionTitle: String?, dismissActionBlock: NIAlertActionBlock, viewController: UIViewController?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            if let acceptActionTitle = acceptActionTitle {
                let acceptAction = UIAlertAction(title: acceptActionTitle, style: .default, handler: acceptActionBlock)
                alertController.addAction(acceptAction)
            }
            if let dismissActionTitle = dismissActionTitle {
                let dismissAction = UIAlertAction(title: dismissActionTitle, style: .destructive, handler: dismissActionBlock)
                alertController.addAction(dismissAction)
            }
            
            if (viewController != nil) {
                viewController?.present(alertController, animated: true, completion: nil)
            } else {
                if let topmostViewController = self.getTopmostViewController() {
                    topmostViewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private static func getTopmostViewController() -> UIViewController? {
        let sceneDelegate = UIApplication.shared.connectedScenes
        .first!.delegate as! SceneDelegate
        if let rootViewController = sceneDelegate.window?.rootViewController {
            if (rootViewController.isKind(of: UINavigationController.self)) {
                return (rootViewController as! UINavigationController).viewControllers.first
            } else if (rootViewController.isKind(of: UITabBarController.self)) {
                return (rootViewController as! UITabBarController).selectedViewController
            } else {
                return rootViewController
            }
        }
        return nil
    }
}
