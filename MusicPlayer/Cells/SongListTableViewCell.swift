//
//  SongListTableViewCell.swift
//  MusicPlayer
//
//  Created by Bindu on 17/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit

class SongListTableViewCell: UITableViewCell {

    @IBOutlet var songImageView: UIImageView!
    @IBOutlet var songTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
