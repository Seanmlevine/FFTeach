//
//  Extensions.swift
//  FFTeach
//
//  Created by Sean Levine on 12/3/21.
//

import Foundation
import CoreMedia
import UIKit

extension NSAttributedString {
    static func makeHyperlink(for path: String, in string: String, as substring: String) -> NSAttributedString {
        let nsString = NSString(string:string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string:string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Light", size: 15) ?? "test", range: substringRange)
        return attributedString
    }
}
