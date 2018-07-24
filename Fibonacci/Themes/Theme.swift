//
//  Theme.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

extension UIColor {
    static func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a / 100)
    }

    static func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.RGB(r, g, b, 100)
    }
}

protocol ThemeProtocol {
    /** The background color of the board base. */
    static func boardColor() -> UIColor

    /** The background color of the entire scene. */
    static func backgroundColor() -> UIColor

    /** The background color of the score board. */
    static func scoreBoardColor() -> UIColor

    /** The background color of the button. */
    static func buttonColor() -> UIColor

    /** The name of the bold font. */
    static func boldFontName() -> String

    /** The name of the regular font. */
    static func regularFontName() -> String

    /**
     * The color for the given level. If level is greater than 15, return the color for Level 15.
     *
     * @param level The level of the tile.
     */
    static func color(forLevel level: Int) -> UIColor

    /**
     * The text color for the given level. If level is greater than 15, return the color for Level 15.
     *
     * @param level The level of the tile.
     */
    static func textColor(forLevel level: Int) -> UIColor
}

class Theme: NSObject {
    /**
     * The theme we are using.
     *
     * @param type The index of the theme.
     */
    class func themeClass(for type: Int) -> AnyClass {
        switch type {
        case 1:
            return VibrantTheme.self
        case 2:
            return JoyfulTheme.self
        default:
            return DefaultTheme.self
        }
    }
}
