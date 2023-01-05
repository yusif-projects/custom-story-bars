//
//  MainVC.swift
//  Custom Story
//
//  Created by Yusif Aliyev on 05.01.23.
//

import UIKit

class MainVC: PrototypeVC {
    
    @IBOutlet weak var customStoryBars: CustomStoryBars!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customStoryBars.storyChanged = { currentIndex in
            print("Story number", currentIndex + 1, "has finished playing.")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        customStoryBars.start()
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        customStoryBars.previous()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        customStoryBars.next()
    }
 
}
