//
//  MainVC.swift
//  Custom Story
//
//  Created by Yusif Aliyev on 05.01.23.
//

import UIKit

class MainVC: PrototypeVC {
    
    @IBOutlet weak var wallpaperView: UIImageView!
    @IBOutlet weak var customStoryBars: CustomStoryBars!
    @IBOutlet weak var holdGestureCatcher: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        holdGestureCatcher.addGestureRecognizer(tap)
        
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(holdHandler))
        hold.minimumPressDuration = 0.5
        holdGestureCatcher.addGestureRecognizer(hold)
        
        customStoryBars.storyItems = [StoryItem(title: "Title 1", description: "Description 1", image: UIImage(named: "1")),
                                      StoryItem(title: "Title 2", description: "Description 2", image: UIImage(named: "2")),
                                      StoryItem(title: "Title 3", description: "Description 3", image: UIImage(named: "3")),
                                      StoryItem(title: "Title 4", description: "Description 4", image: UIImage(named: "4")),
                                      StoryItem(title: "Title 5", description: "Description 5", image: UIImage(named: "5")),
                                      StoryItem(title: "Title 6", description: "Description 6", image: UIImage(named: "6")),
                                      StoryItem(title: "Title 7", description: "Description 7", image: UIImage(named: "7"))]
        
        wallpaperView.image = customStoryBars.storyItems[customStoryBars.currentStoryIndex].image
        
        customStoryBars.storyChanged = { currentIndex in
            print("Story number", currentIndex + 1, "has finished playing.")
            self.wallpaperView.image = self.customStoryBars.storyItems[currentIndex].image
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        customStoryBars.start()
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        customStoryBars.handleTap(sender)
    }
    
    @objc func holdHandler(_ sender: UILongPressGestureRecognizer) {
        customStoryBars.handleHold(sender)
    }
 
}
