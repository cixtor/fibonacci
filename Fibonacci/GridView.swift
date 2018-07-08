//
//  GridView.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

class GridView: UIView {
    init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = GSTATE.scoreBoardColor()
        layer.cornerRadius = GSTATE.cornerRadius
        layer.masksToBounds = true
    }
    
    convenience init() {
        let side = Int(GSTATE.dimension * (CGFloat(GSTATE.tileSize) + GSTATE.borderWidth) + GSTATE.borderWidth)
        let verticalOffset: CGFloat = UIScreen.main.bounds.size.height - GSTATE.verticalOffset
        self.init(frame: CGRect(x: GSTATE.horizontalOffset, y: verticalOffset - CGFloat(side), width: CGFloat(side), height: CGFloat(side)))
    }
    
    /**
     * Create the entire background of the view with the grid at the correct position.
     *
     * @param grid The grid object that the image bases on.
     */
    class func gridImage(with grid: M2Grid?) -> UIImage? {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = GSTATE.backgroundColor
        let view = M2GridView()
        backgroundView.addSubview(view)
        grid?.forEach({ position in
            let layer = CALayer()
            let point: CGPoint = GSTATE.locationOf(position)
            var frame: CGRect = layer.frame
            frame.size = CGSize(width: CGFloat(GSTATE.tileSize), height: CGFloat(GSTATE.tileSize))
            frame.origin = CGPoint(x: point.x, y: UIScreen.main.bounds.size.height - point.y - CGFloat(GSTATE.tileSize))
            layer.frame = frame
            layer.backgroundColor = GSTATE.boardColor().cgColor
            layer.cornerRadius = GSTATE.cornerRadius
            layer.masksToBounds = true
            backgroundView.layer.addSublayer(layer)
        }, reverseOrder: false)
        return M2GridView.snapshot(with: backgroundView)
    }
    
    /**
     * Create the entire background of the view with a translucent overlay on the grid.
     * The rest of the image is clear color, to create the illusion that the overlay is
     * only over the grid.
     */
    class func gridImageWithOverlay() -> UIImage? {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.isOpaque = false
        let view = M2GridView()
        view.backgroundColor = GSTATE.backgroundColor?.withAlphaComponent(0.8)
        backgroundView.addSubview(view)
        return M2GridView.snapshot(with: backgroundView)
    }
    
    class func snapshot(with view: UIView?) -> UIImage? {
        // This is a little hacky, but is probably the best generic way to do this.
        // [UIColor colorWithPatternImage] doesn't really work with SpriteKit, and we need
        // to take a retina-quality screenshot. But then in SpriteKit we need to shrink the
        // corresponding node back to scale 1.0 in order for it to display properly.
        UIGraphicsBeginImageContextWithOptions(view?.frame.size, view?.isOpaque, 0.0)
        if let aContext = UIGraphicsGetCurrentContext() {
            view?.layer.render(in: aContext)
        }
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
