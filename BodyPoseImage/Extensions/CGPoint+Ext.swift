//
//  CGPoint+Ext.swift
//  BodyPoseImage
//
//  Created by Kristanto Sean on 06/06/24.
//

import Foundation

extension CGPoint {
    func translateFromCoreImageToUIKitCoordinateSpace(using height: CGFloat) -> CGPoint {
        let transform = CGAffineTransform(scaleX: 1, y: -1)
            .translatedBy(x: 0, y: -height);
        
        return self.applying(transform)
    }
}
