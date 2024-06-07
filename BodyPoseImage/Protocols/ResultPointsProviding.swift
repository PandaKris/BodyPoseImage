//
//  ResultPointsProviding.swift
//  BodyPoseImage
//
//  Created by Kristanto Sean on 06/06/24.
//

import Foundation
import UIKit

protocol ResultPointsProviding {
    func pointsProjected(onto image: UIImage) -> [CGPoint]
    func openPointGroups(projectedOnto image: UIImage) -> [[CGPoint]]
    func closedPointGroups(projectedOnto image: UIImage) -> [[CGPoint]]
}





