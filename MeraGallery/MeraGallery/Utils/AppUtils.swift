//
//  AppUtils.swift
//  MeraGallery
//
//  Created by NhatMinh on 12/11/2022.
//

import Foundation

class AppUtils {
    
    static func delay(_ delay: Double, closure: @escaping () -> Void) {
        let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(
            deadline: deadline,
            execute: closure
        )
    }
}
