//
//  VNDetectFaceLandmarksRequest+Ext.swift
//  BodyPoseImage
//
//  Created by Kristanto Sean on 06/06/24.
//

import Foundation
import Vision
import UIKit

extension VNDetectFaceLandmarksRequest: ResultPointsProviding {
    func pointsProjected(onto image: UIImage) -> [CGPoint] { [] }
    
    func openPointGroups(projectedOnto image: UIImage) -> [[CGPoint]] {
        guard let results = results else { return [] }
        let landmarks = results.compactMap { [$0.landmarks?.leftEyebrow,
                                              $0.landmarks?.rightEyebrow,
                                              $0.landmarks?.faceContour,
                                              $0.landmarks?.noseCrest,
                                              $0.landmarks?.medianLine].compactMap { $0 } }
        
        return points(landmarks: landmarks, projectedOnto: image)
    }
    
    func closedPointGroups(projectedOnto image: UIImage) -> [[CGPoint]] {
        guard let results = results else { return [] }
        let landmarks = results.compactMap { [$0.landmarks?.leftEye,
                                              $0.landmarks?.rightEye,
                                              $0.landmarks?.outerLips,
                                              $0.landmarks?.innerLips,
                                              $0.landmarks?.nose].compactMap { $0 } }
        
        return points(landmarks: landmarks, projectedOnto: image)
    }
    
    func points(landmarks: [[VNFaceLandmarkRegion2D]], projectedOnto image: UIImage) -> [[CGPoint]] {
        let faceLandmarks = landmarks.flatMap { $0 }
            .compactMap { landmark in
                landmark.pointsInImage(imageSize: image.size)
                    .map { $0.translateFromCoreImageToUIKitCoordinateSpace(using: image.size.height) }
            }
        
        return faceLandmarks
    }
}
