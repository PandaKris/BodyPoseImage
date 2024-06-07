//
//  VisionDetector.swift
//  BodyPoseImage
//
//  Created by Kristanto Sean on 06/06/24.
//

import Foundation
import UIKit
import Vision

class VisionDetector: ObservableObject {
    
    @Published var isBodyPoseRequired = false
    @Published var isHandPoseRequired = false
    @Published var isFaceLandmarksRequired = false
    
    @Published var isProcessing = false
    
    @Published var selectedImage: UIImage? = nil
    @Published var processedImage: UIImage? = nil

    @Published var durationLabel = "0.0"

    private let visionQueue = DispatchQueue.global(qos: .userInitiated)
    

    func process() {
        guard let image = selectedImage else { return }
        
        guard let cgImage = image.cgImage else { return }
        
        
        guard isBodyPoseRequired || isHandPoseRequired || isFaceLandmarksRequired else {
            processedImage = selectedImage
            return
        }
        
        isProcessing = true
        durationLabel = "0.0"
        
        visionQueue.async { [weak self] in
            guard let self = self else { return }
            let requests = [
                isBodyPoseRequired ? VNDetectHumanBodyPoseRequest() : nil,
                isHandPoseRequired ? VNDetectHumanHandPoseRequest(maximumHandCount: 10) : nil,
                isFaceLandmarksRequired ? VNDetectFaceLandmarksRequest() : nil
            ].compactMap { $0 }

            let requestHandler = VNImageRequestHandler(
                cgImage: cgImage,
                orientation: .init(image.imageOrientation),
                options: [:]
            )
            
            var processingTime: Double = 0.0
            
            do {
                let startProcessingDate = Date()
                try requestHandler.perform(requests)
                processingTime = (Date().timeIntervalSince(startProcessingDate) * 100).rounded() / 100
            } catch {
                isProcessing = false
                print("Can't make the request due to \(error)")
            }

            let resultPointsProviders = requests.compactMap { $0 as? ResultPointsProviding }
            
            let openPointsGroups = resultPointsProviders
                .flatMap { $0.openPointGroups(projectedOnto: image) }
            
            let closedPointsGroups = resultPointsProviders
                .flatMap { $0.closedPointGroups(projectedOnto: image) }

            var points: [CGPoint]?
            let isDetectingFaceLandmarks = requests.filter { ($0 as? VNDetectFaceLandmarksRequest)?.results?.isEmpty == false }.isEmpty == false

            points = resultPointsProviders
                .filter { !isDetectingFaceLandmarks || isDetectingFaceLandmarks && !($0 is VNDetectHumanBodyPoseRequest) }
                .flatMap { $0.pointsProjected(onto: image) }

            
            DispatchQueue.main.async {
                self.durationLabel = "\(processingTime)"
                self.isProcessing = false
                self.processedImage = image.draw(
                    openPaths: openPointsGroups,
                    closedPaths: closedPointsGroups,
                    points: points
                )
            }
        }
    }
}
