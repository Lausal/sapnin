//
//  ContactsModel.swift
//  Sapnin
//
//  Created by Alan Lau on 24/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

class ContactsModel {
    
    let contactId: String
    let givenName: String
    let familyName: String
    let phoneNumber: String?
    
    init(contactId: String, givenName: String, familyName: String, phoneNumber: String) {
        self.contactId = contactId
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
    }
    
    var titleFirstLetter: String {
        return String(self.givenName[self.givenName.startIndex]).uppercased()
    }
    
}
