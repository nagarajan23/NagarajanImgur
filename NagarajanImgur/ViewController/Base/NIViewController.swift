//
//  NIViewController.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 18/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import UIKit

class NIViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var navigationView: UIView!

    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeOnViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.initializeOnViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK:- Custom Initialization
    func initializeOnViewDidLoad() {
        
    }
    
    func initializeOnViewWillAppear() {
        
    }
    
    //MARK:- Button Action
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- View Shadow Initialization
//MARK: Navigation View
extension NIViewController {
    func addBottomShadowForNavigationBar() {
        self.addBottomShadow(view: self.navigationView)
    }
    
    func addBottomShadow(view: UIView) {
        NIViewEffects.setShadowEffectAtBottom(forView: view, color: UIColor(hex: "#969696FF") ?? UIColor.clear)
        self.view.bringSubviewToFront(view)
    }
}

//MARK:- Nib File Load
extension NIViewController {
    func loadNibFile(fileName:String) -> Any? {
        return Bundle.main.loadNibNamed(fileName, owner: self, options: nil)?.first
    }
}

//MARK:- Navigate
extension NIViewController {
    func navigateToViewController(controller: UIViewController, animated: Bool) {
        if self.navigationController?.responds(to: #selector(show(_:sender:))) ?? false {
            self.navigationController?.show(controller, sender: self)
        } else {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
