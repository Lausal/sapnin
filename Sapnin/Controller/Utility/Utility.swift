//
//  Utility.swift
//  Sapnin
//
//  Created by Alan Lau on 06/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    func styleTextField(textfield: UITextField, text: String) {
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = BrandColours.FIELD_BORDER_COLOUR.cgColor
        textfield.backgroundColor = BrandColours.FIELD_BACKGROUND_COLOUR
        textfield.layer.cornerRadius = 5
        textfield.font = UIFont(name: "Roboto-Regular", size: 14)
        
        // Set left and right padding of text field input
        textfield.addPadding(.both(16))
        
        // Set placeholder styling
        let placeholderAttr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : BrandColours.PLACEHOLDER_TEXT_COLOUR])
        textfield.attributedPlaceholder = placeholderAttr
        
        // Specify text colour
        textfield.textColor = BrandColours.PINK
    }
    
    // This function is used to identify the top hierarchy view controller so that it allows us to present a modal on top
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
}
