//
//  Extension.swift
//  Sapnin
//
//  Created by Alan Lau on 27/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit
import SDWebImage

@IBDesignable
extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

extension UIImageView {
    
    // Function to load URL into an image using the SDWebImage API
    func loadImage(_ urlString: String?, onSuccess: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else { return }
        guard let url = URL(string: string) else { return }
        
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }
    
}

// Converts timelapse status of post date to current time
func timeAgoSinceDate(_ date:Date, currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!)yrs"
    } else if (components.year! >= 1){
        if (numericDates){ return "1yr"
        } else { return "Last year" }
    } else if (components.month! >= 2) {
        return "\(components.month!)mo's"
    } else if (components.month! >= 1){
        if (numericDates){ return "1mo"
        } else { return "Last month" }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!)wks"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){ return "1wk ago"
        } else { return "Last week" }
    } else if (components.day! >= 2) {
        return "\(components.day!)d"
    } else if (components.day! >= 1){
        if (numericDates){ return "1d"
        } else { return "Yesterday" }
    } else if (components.hour! >= 2) {
        return "\(components.hour!)hrs"
    } else if (components.hour! >= 1){
        if (numericDates){ return "1hr"
        } else { return "An hour ago" }
    } else if (components.minute! >= 2) {
        return "\(components.minute!)m"
    } else if (components.minute! >= 1){
        if (numericDates){ return "1m"
        } else { return "A minute ago" }
    } else if (components.second! >= 3) {
        return "\(components.second!)s ago"
    } else { return "Just now" }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
