//
//  ContactsModel.swift
//  Sapnin
//
//  Created by Alan Lau on 24/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

class ContactsModel {
    
    let contactId: String?
    let givenName: String
    var familyName: String
    let phoneNumber: String?
    var isUserRegistered: Bool
    
    init(contactId: String?, givenName: String, familyName: String, phoneNumber: String, isUserRegistered: Bool) {
        self.contactId = contactId
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        self.isUserRegistered = isUserRegistered
    }
    
    var titleFirstLetter: String {
        return String(self.givenName[self.givenName.startIndex]).uppercased()
    }
    
}
