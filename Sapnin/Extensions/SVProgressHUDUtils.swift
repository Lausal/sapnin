//
//  SVProgressHUDUtils.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 13/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation
import SVProgressHUD

extension SVProgressHUD {
    open class func show(_ status: String, maxTime: TimeInterval) {
        SVProgressHUD.show(withStatus: status)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + maxTime) {
            SVProgressHUD.dismiss()
        }
    }
}
