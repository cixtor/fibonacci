//
//  ScoreView.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var score: UILabel!
    
    init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = GSTATE.cornerRadius
        layer.masksToBounds = true
        backgroundColor = UIColor.green
    }
    
    func updateAppearance() {
        backgroundColor = GSTATE.scoreBoardColor()
        title.font = UIFont(name: GSTATE.boldFontName(), size: 12)
        score.font = UIFont(name: GSTATE.regularFontName(), size: 16)
    }
}
