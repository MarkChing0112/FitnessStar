//
//  MakeHyperLink.swift
//  FypTest_APP
//
//  Created by kin ming ching on 7/5/2022.
//

import Foundation
extension NSAttributedString{
    
    static func makeHypelink(for path: String, in string: String, as substring: String) -> NSAttributedString{
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        return attributedString
    }
    
}
