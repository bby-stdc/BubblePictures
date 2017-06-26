//
//  BPCollectionViewCell.swift
//  Pods
//
//  Created by Kevin Belter on 1/2/17.
//
//

import UIKit

class BPCollectionViewCell: UICollectionViewCell {
    
    class var className: String { return "BPCollectionViewCell" }
    
    @IBOutlet weak var viewWhiteBorders: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBackgroundWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNameCenterXConstraint: NSLayoutConstraint!
    private let borderLayer: CAShapeLayer! = nil
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        viewWhiteBorders.layer.masksToBounds = true
        viewWhiteBorders.layer.cornerRadius = viewWhiteBorders.bounds.height / 2.0
        
        imgBackground.layer.masksToBounds = true
        imgBackground.layer.cornerRadius = imgBackground.bounds.height / 2.0
        
        viewBackground.layer.masksToBounds = true
        viewBackground.layer.cornerRadius = viewBackground.bounds.height / 2.0
    }
    
    func configure(configFile: BPCellConfigFile, layoutConfigurator: BPLayoutConfigurator, isTruncatedCell: Bool) {
        self.backgroundColor = UIColor.clear
        
        viewBackground.isHidden = false
        
        configureImage(imageType: configFile.imageType, title: configFile.title, layoutConfigurator: layoutConfigurator)
        configureTitle(fullTitle: configFile.title, maxLenght: layoutConfigurator.maxCharactersForBubbleTitles, isTruncatedCell: isTruncatedCell)
        configureLayout(borderColor: configFile.borderColor)
        
        viewBackgroundWidthConstraint.constant = layoutConfigurator.widthForBubbleBorders * -2
        lblNameCenterXConstraint.constant = isTruncatedCell ? -2 : -4
        
    }
    
    private func configureImage(imageType: BPImageType, title: String, layoutConfigurator: BPLayoutConfigurator) {
        switch imageType {
        case .image(let image):
            self.imgBackground.image = image
            self.viewBackground.isHidden = title == ""
        case .URL(let url):
            self.imgBackground.setImageWithURLAnimated(url)
            self.viewBackground.isHidden = title == ""
        case .color(let color):
            self.imgBackground.image = UIImage(color: color)
            self.viewBackground.isHidden = true
        }
        imgBackground.contentMode = layoutConfigurator.bubbleImageContentMode
    }
    
    private func configureLayout(borderColor: UIColor) {
        
        func animateCircle(duration: TimeInterval, circleLayer: CAShapeLayer) {
            // We want to animate the strokeEnd property of the circleLayer
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            // Set the animation duration appropriately
            animation.duration = duration
            
            // Animate from 0 (no circle) to 1 (full circle)
            animation.fromValue = 0
            animation.toValue = 1
            
            // Do a linear animation (i.e. the speed of the animation stays the same)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
            // right value when the animation ends.
            circleLayer.strokeEnd = 1.0
            
            // Do the actual animation
            circleLayer.add(animation, forKey: "animateCircle")
        }
        
        func addBorderLayer(borderCGColor: CGColor) {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 4)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
            
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = borderCGColor
            circleLayer.lineWidth = 2.0;
            
            circleLayer.strokeEnd = 0.0
            animateCircle(duration: 2.0, circleLayer: circleLayer)
            layer.addSublayer(circleLayer)
        }
        guard let existingBorder = borderLayer, existingBorder.fillColor != borderColor.cgColor else {
            addBorderLayer(borderCGColor: borderColor.cgColor)
            return
        }
        addBorderLayer(borderCGColor: borderColor.cgColor)
    }
    
    private func configureTitle(fullTitle: String, maxLenght: Int, isTruncatedCell: Bool) {
        var name = ""
        defer { lblName.text = isTruncatedCell ? fullTitle : "" }
        
        if isTruncatedCell {
            name = fullTitle
            return
        }
        
        let names = fullTitle.components(separatedBy: " ")
        
        if names.count == 1 {
            guard let uniqueName = names.first?.substring(to: maxLenght) else { return }
            name = uniqueName
            return
        }
        
        for (index, truncatedName) in names.enumerated() {
            if index == maxLenght { return }
            
            name = "\(name + truncatedName.substring(to: 1))"
        }
    }
}
