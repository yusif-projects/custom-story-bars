//
//  CustomStoryBars.swift
//  Custom Story
//
//  Created by Yusif Aliyev on 05.01.23.
//

import UIKit

@IBDesignable
class CustomStoryBars: UIView {
    
    @IBInspectable public var emptyColor: UIColor = .gray
    @IBInspectable public var fullColor: UIColor = .black
    
    @IBInspectable public var interItemSpacing: CGFloat = 8
    @IBInspectable public var horizontalMargins: CGFloat = 16
    @IBInspectable public var barHeight: CGFloat = 4
    
    @IBInspectable public var numberOfStories: Int = 0
    @IBInspectable public var currentStoryIndex: Int = 0
    
    @IBInspectable public var storyDuration: TimeInterval = 3
    @IBInspectable public var fps: TimeInterval = 30
    
    private var widthConstraints: [NSLayoutConstraint] = []
    
    private var timer: Timer!
    
    private var goalWidth: CGFloat!
    private var stepWidth: CGFloat!
    
    private var backgroundView: UIView!
    private var stackView: UIStackView!
    
    public var storyChanged: ((Int) -> ())?
    
    public var storyItems: [StoryItem] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        numberOfStories = storyItems.count
        
        if !self.subviews.isEmpty {
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
        } else {
            let stackViewWidth = self.frame.size.width - horizontalMargins * 2
            let totalSpacing = interItemSpacing * CGFloat(numberOfStories - 1)
            
            goalWidth = (stackViewWidth - totalSpacing) / CGFloat(numberOfStories)
            stepWidth = goalWidth / CGFloat(fps * storyDuration)
            
            createBackgroundView()
            createStackView()
            createBars()
        }
    }
    
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1/fps, repeats: true, block: { t in
            
            if self.widthConstraints[self.currentStoryIndex].constant >= self.goalWidth {
                if self.currentStoryIndex < self.numberOfStories - 1 {
                    self.currentStoryIndex = self.currentStoryIndex + 1
                    
                    self.storyChanged?(self.currentStoryIndex)
                } else {
                    t.invalidate()
                }
            } else {
                self.widthConstraints[self.currentStoryIndex].constant = self.widthConstraints[self.currentStoryIndex].constant + self.stepWidth
            }
            
        })
    }
    
    public func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.location(in: sender.view!).x >= sender.view!.frame.size.width / 2 {
            self.next()
        } else {
            self.previous()
        }
    }
    
    public func handleHold(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended, .cancelled, .failed:
            self.start()
        default:
            self.stop()
        }
    }
    
    private func stop() {
        timer.invalidate()
    }
    
    private func previous() {
        if !timer.isValid {
            self.start()
        }
        
        if currentStoryIndex > 0 {
            widthConstraints[currentStoryIndex].constant = 0
            widthConstraints[currentStoryIndex - 1].constant = 0
            currentStoryIndex = currentStoryIndex - 1
            
            self.storyChanged?(self.currentStoryIndex)
        } else {
            widthConstraints[currentStoryIndex].constant = 0
        }
    }
    
    private func next() {
        if currentStoryIndex < numberOfStories - 1 {
            widthConstraints[currentStoryIndex].constant = goalWidth
            currentStoryIndex = currentStoryIndex + 1
            
            self.storyChanged?(self.currentStoryIndex)
        } else {
            widthConstraints[currentStoryIndex].constant = goalWidth
        }
    }
    
    private func createBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        
        addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        if let backgroundView = backgroundView {
            NSLayoutConstraint(item: backgroundView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    private func createStackView() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = interItemSpacing
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.backgroundColor = .clear
        
        backgroundView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if let stackView = stackView {
            NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: backgroundView, attribute: .width, multiplier: 1, constant: -2 * horizontalMargins).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: barHeight).isActive = true
        }
    }
    
    private func createBars() {
        for i in 0 ..< numberOfStories {
            let bar = UIView()
            bar.layer.cornerRadius = barHeight / 2
            bar.clipsToBounds = true
            bar.backgroundColor = self.emptyColor
            
            stackView.addArrangedSubview(bar)
            
            let barFill = UIView()
            barFill.backgroundColor = self.fullColor
            bar.addSubview(barFill)
            
            barFill.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: barFill, attribute: .top, relatedBy: .equal, toItem: bar, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: barFill, attribute: .leading, relatedBy: .equal, toItem: bar, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: barFill, attribute: .bottom, relatedBy: .equal, toItem: bar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            
            var width: CGFloat = 0
            
            if i < currentStoryIndex {
                width = goalWidth
            } else {
                width = 0
            }
            
            let barFillWidth = NSLayoutConstraint(item: barFill, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width)
            barFillWidth.isActive = true
            
            widthConstraints.append(barFillWidth)
        }
    }
    
}

public struct StoryItem {
    var title: String!
    var description: String!
    var image: UIImage!
    
    init(title: String!, description: String!, image: UIImage!) {
        self.title = title
        self.description = description
        self.image = image
    }
}
