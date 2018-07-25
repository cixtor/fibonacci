//
//  JoyfulTheme.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

class JoyfulTheme: ThemeProtocol {
    func color(forLevel level: Int) -> UIColor {
        switch level {
        case 1:
            return UIColor.RGB(236, 243, 251)
        case 2:
            return UIColor.RGB(230, 245, 252)
        case 3:
            return UIColor.RGB(95, 131, 157)
        case 4:
            return UIColor.RGB(164, 232, 254)
        case 5:
            return UIColor.RGB(226, 246, 209)
        case 6:
            return UIColor.RGB(237, 228, 253)
        case 7:
            return UIColor.RGB(254, 224, 235)
        case 8:
            return UIColor.RGB(254, 235, 115)
        case 9:
            return UIColor.RGB(255, 249, 136)
        case 10:
            return UIColor.RGB(208, 246, 247)
        case 11:
            return UIColor.RGB(251, 244, 236)
        case 12:
            return UIColor.RGB(254, 237, 229)
        case 13:
            return UIColor.RGB(205, 247, 235)
        case 14:
            return UIColor.RGB(57, 120, 104)
        case 15:
            fallthrough
        default:
            return UIColor.RGB(93, 125, 62)
        }
    }

    func textColor(forLevel level: Int) -> UIColor {
        switch level {
        case 1:
            return UIColor.RGB(104, 119, 131)
        case 2:
            return UIColor.RGB(70, 128, 161)
        case 3:
            return UIColor.white
        case 4:
            return UIColor.RGB(64, 173, 246)
        case 5:
            return UIColor.RGB(97, 159, 42)
        case 6:
            return UIColor.RGB(124, 85, 201)
        case 7:
            return UIColor.RGB(223, 73, 115)
        case 8:
            return UIColor.RGB(244, 111, 41)
        case 9:
            return UIColor.RGB(253, 160, 46)
        case 10:
            return UIColor.RGB(30, 160, 158)
        case 11:
            return UIColor.RGB(147, 129, 115)
        case 12:
            return UIColor.RGB(162, 93, 60)
        case 13:
            return UIColor.RGB(68, 227, 184)
        case 14, 15:
            fallthrough
        default:
            return UIColor.white
        }
    }

    func backgroundColor() -> UIColor {
        return UIColor.RGB(255, 254, 237)
    }

    func boardColor() -> UIColor {
        return UIColor.RGB(255, 254, 237)
    }

    func scoreBoardColor() -> UIColor {
        return UIColor.RGB(243, 168, 40)
    }

    func buttonColor() -> UIColor {
        return UIColor.RGB(242, 79, 46)
    }

    func boldFontName() -> String {
        return "AvenirNext-DemiBold"
    }

    func regularFontName() -> String {
        return "AvenirNext-Regular"
    }
}
