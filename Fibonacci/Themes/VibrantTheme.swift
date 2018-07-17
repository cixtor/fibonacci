//
//  VibrantTheme.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

class VibrantTheme: NSObject, Theme {
    class func color(forLevel level: Int) -> UIColor? {
        switch level {
        case 1:
            return RGB(254, 223, 180)
        case 2:
            return RGB(254, 183, 143)
        case 3:
            return RGB(253, 187, 45)
        case 4:
            return RGB(253, 157, 40)
        case 5:
            return RGB(246, 124, 95)
        case 6:
            return RGB(217, 70, 119)
        case 7:
            return RGB(210, 65, 97)
        case 8:
            return RGB(207, 50, 90)
        case 9:
            return RGB(205, 35, 84)
        case 10:
            return RGB(200, 30, 78)
        case 11:
            return RGB(190, 20, 70)
        case 12:
            return RGB(254, 233, 78)
        case 13:
            return RGB(249, 191, 64)
        case 14:
            return RGB(247, 167, 56)
        case 15:
            fallthrough
        default:
            return RGB(244, 138, 48)
        }
    }
    
    class func textColor(forLevel level: Int) -> UIColor? {
        switch level {
        case 1, 2:
            return RGB(150, 110, 90)
        case 3, 4, 5, 6, 7, 8, 9, 10, 11:
            fallthrough
        default:
            return UIColor.white
        }
    }
    
    class func backgroundColor() -> UIColor? {
        return RGB(240, 240, 240)
    }
    
    class func boardColor() -> UIColor? {
        return RGB(240, 240, 240)
    }
    
    class func scoreBoardColor() -> UIColor? {
        return RGB(253, 144, 38)
    }
    
    class func buttonColor() -> UIColor? {
        return RGB(205, 35, 85)
    }
    
    class func boldFontName() -> String? {
        return "AvenirNext-DemiBold"
    }
    
    class func regularFontName() -> String? {
        return "AvenirNext-Regular"
    }
}
