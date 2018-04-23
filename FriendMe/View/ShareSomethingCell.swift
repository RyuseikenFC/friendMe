//
//  ShareSomethingCell.swift
//  FriendMe
//
//  Created by Steven on 4/1/18.
//  Copyright © 2018 Steven. All rights reserved.
//

import UIKit
import Firebase

class ShareSomethingCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(userImgUrl: String){
        let httpsRefrence = Storage.storage().reference(forURL: userImgUrl)
        
        httpsRefrence.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                
            } else {
                let image = UIImage(data: data!)
                self.userImgView.image = image
            }
        }
    }
}
