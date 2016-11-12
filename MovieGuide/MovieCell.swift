//
//  MovieCell.swift
//  MovieGuide
//
//  Created by Chengjiu Hong on 10/28/16.
//  Copyright © 2016 Chengjiu Hong. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
     var movie : Movie! {
        didSet {
            titleLabel.text = movie.movieTitle

            if(movie.moviePosterUrl != nil) {
                posterImageView.af_setImage(withURL: URL(string: movie.moviePosterUrl!)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
