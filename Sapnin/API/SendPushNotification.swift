//
//  Configs.swift
//  Sapnin
//
//  Created by Alan Lau on 25/08/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation

let fcmUrl = "https://fcm.googleapis.com/fcm/send" //URL to send request - this is provided by Firebase
let serverKey = "AAAAlfX45kc:APA91bGwNNZVi3DY_n7eAWk9OFBcoiY7ZfewWHL68kbsuYJVRZST39OhCJOSLrV1F0MPwkeTlFVyQq-n_OfjXdyrdzpaiJ7fZxkSJQrZQHpRZKdNY2nsz_uv7kSwr9NqbQlWts68edUM" // From Firebase

// Format and send notification message using HTTP Post
func sendPushNotifications(channelName: String, fromUser: User, toUser: User, badge: Int) {
    // Set up HTTP Post request
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    // Set up the content of the notification message. CustomData is used for when we tap on the notification so that we can specifiy which chat scene and page to go to.
//    let notification: [String: Any] = [ "to" : "/topics/\(toUser.userId)",
//        "notification" : ["title": (isMatch == false) ? fromUser.name : "New match",
//                          "body": message,
//                          "sound": "default",
//                          "badge": badge,
//                          "customData": ["userId": fromUser.userId,
//                                         "username": fromUser.name,
//                                         "email": fromUser.email,
//                                         "profileImageUrl": fromUser.profilePictureUrl]
//        ]
//    ]
    
    let notification: [String: Any] = [ "to" : toUser.tokenID,
        "notification" : ["title": channelName,
                          "body": fromUser.name + " shared a photo",
                          "sound": "default",
                          "badge": badge,
                          "customData": ["userId": fromUser.userId,
                                         "username": fromUser.name,
                                         "email": fromUser.email,
                                         "profileImageUrl": fromUser.profilePictureUrl]
        ]
    ]
    
    
    // Send notification request
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("httpResponse \(httpResponse.statusCode)")
            print("Response \(response)")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
        }.resume()
}

// Format and send broadcast push notification message using HTTP Post
func sendBroadcastPushNotifications(emoji: String, activity: String, fromUser: User, toUser: User, badge: Int) {
    // Set up HTTP Post request
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"

    let notification: [String: Any] = [ "to" : toUser.tokenID,
                                        "notification" : ["title": fromUser.name,
                                                          "body": "Is " + activity.lowercased() + " " + emoji,
                                                          "sound": "default",
                                                          "badge": badge,
                                                          "customData": ["userId": fromUser.userId,
                                                                         "username": fromUser.name,
                                                                         "email": fromUser.email,
                                                                         "profileImageUrl": fromUser.profilePictureUrl]
        ]
    ]
    
    
    // Send notification request
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("httpResponse \(httpResponse.statusCode)")
            print("Response \(response)")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
        }.resume()
}
