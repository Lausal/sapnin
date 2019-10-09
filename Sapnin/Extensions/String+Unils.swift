//
//  String+Unils.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 19/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation

extension String{
    
    mutating func removeSpacesAndSpecialCharacters()-> String{
        
        self = self.replacingOccurrences(of: " ", with: "")
        self = self.replacingOccurrences(of: "(", with: "")
        self = self.replacingOccurrences(of: ")", with: "")
        self = self.replacingOccurrences(of: "-", with: "")
        self = self.replacingOccurrences(of: "_", with: "")
        
        return self
    }
    
}
