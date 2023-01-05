//
//  PrototypeVC.swift
//  Custom Story
//
//  Created by Yusif Aliyev on 05.01.23.
//

import UIKit

class PrototypeVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
    }

}
