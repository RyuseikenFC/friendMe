//
//  CircleView.swift
//  FriendMe
//
//  Created by Steven on 4/1/18.
//  Copyright © 2018 Steven. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
    }

}
