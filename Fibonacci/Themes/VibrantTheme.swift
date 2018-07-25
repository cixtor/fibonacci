//
//  VibrantTheme.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

class VibrantTheme: Theme, ThemeProtocol {
    func color(forLevel level: Int) -> UIColor {
        switch level {
        case 1:
            return UIColor.RGB(254, 223, 180)
        case 2:
            return UIColor.RGB(254, 183, 143)
        case 3:
            return UIColor.RGB(253, 187, 45)
        case 4:
            return UIColor.RGB(253, 157, 40)
        case 5:
            return UIColor.RGB(246, 124, 95)
        case 6:
            return UIColor.RGB(217, 70, 119)
        case 7:
            return UIColor.RGB(210, 65, 97)
        case 8:
            return UIColor.RGB(207, 50, 90)
        case 9:
            return UIColor.RGB(205, 35, 84)
        case 10:
            return UIColor.RGB(200, 30, 78)
        case 11:
            return UIColor.RGB(190, 20, 70)
        case 12:
            return UIColor.RGB(254, 233, 78)
        case 13:
            return UIColor.RGB(249, 191, 64)
        case 14:
            return UIColor.RGB(247, 167, 56)
        case 15:
            fallthrough
        default:
            return UIColor.RGB(244, 138, 48)
        }
    }

    func textColor(forLevel level: Int) -> UIColor {
        switch level {
        case 1, 2:
            return UIColor.RGB(150, 110, 90)
        case 3, 4, 5, 6, 7, 8, 9, 10, 11:
            fallthrough
        default:
            return UIColor.white
        }
    }

    func backgroundColor() -> UIColor {
        return UIColor.RGB(240, 240, 240)
    }

    func boardColor() -> UIColor {
        return UIColor.RGB(240, 240, 240)
    }

    func scoreBoardColor() -> UIColor {
        return UIColor.RGB(253, 144, 38)
    }

    func buttonColor() -> UIColor {
        return UIColor.RGB(205, 35, 85)
    }

    func boldFontName() -> String {
        return "AvenirNext-DemiBold"
    }

    func regularFontName() -> String {
        return "AvenirNext-Regular"
    }
}
