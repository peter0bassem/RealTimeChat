//
//  RoundedImage.swift
//  The Avenue Agent
//
//  Created by Peter Bassem on 5/19/18.
//  Copyright © 2018 Ashraf Essam. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
}
