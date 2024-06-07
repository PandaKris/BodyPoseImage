//
//  VNDetectHumanHandPoseRequest+Ext.swift
//  BodyPoseImage
//
//  Created by Kristanto Sean on 06/06/24.
//

import Foundation
import Vision
import UIKit

extension VNDetectHumanHandPoseRequest: ResultPointsProviding {
    func pointsProjected(onto image: UIImage) -> [CGPoint] { [] }
    func closedPointGroups(projectedOnto image: UIImage) -> [[CGPoint]] { [] }
    func openPointGroups(projectedOnto image: UIImage) -> [[CGPoint]] {
        point(jointGroups: [[.wrist, .indexMCP, .indexPIP, .indexDIP, .indexTip],
                            [.wrist, .littleMCP, .littlePIP, .littleDIP, .littleTip],
                            [.wrist, .middleMCP, .middlePIP, .middleDIP, .middleTip],
                            [.wrist, .ringMCP, .ringPIP, .ringDIP, .ringTip],
                            [.wrist, .thumbCMC, .thumbMP, .thumbIP, .thumbTip]],
                            projectedOnto: image)
    }
    
    func point(jointGroups: [[VNHumanHandPoseObservation.JointName]], projectedOnto image: UIImage) -> [[CGPoint]] {
        guard let results = results else { return [] }
        let pointGroups = results.map { result in
            jointGroups
                .compactMap { joints in
                    joints.compactMap { joint in
                        try? result.recognizedPoint(joint)
                    }
                    .filter { $0.confidence > 0.1 }
                    .map { $0.location(in: image) }
                    .map { $0.translateFromCoreImageToUIKitCoordinateSpace(using: image.size.height) }
                }
        }
        
        return pointGroups.flatMap { $0 }
    }
    
    convenience init(maximumHandCount: Int) {
        self.init()
        self.maximumHandCount = maximumHandCount
    }
}
