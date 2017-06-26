//
//  BubblePictureCellConfigFile.swift
//  Pods
//
//  Created by Kevin Belter on 1/2/17.
//
//

import UIKit

public struct BPCellConfigFile {
    var imageType: BPImageType
    var title: String
    var borderColor: UIColor
    
    public init(imageType: BPImageType, title: String, borderColor: UIColor) {
        self.imageType = imageType
        self.title = title
        self.borderColor = borderColor
    }
}
