//
//  ContentView.swift
//  BodyPoseImage
//
//  Created by Kristanto Sean on 06/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var visionDetector = VisionDetector()
    
    @State var isShowingImagePicker = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let image = visionDetector.selectedImage {
                    Image(
                        uiImage: (
                            visionDetector.processedImage != nil
                        ) ? visionDetector.processedImage! : image
                    )
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height:geometry.size.height/2)
                    
                    Button {
                        visionDetector.isBodyPoseRequired.toggle()
                        visionDetector.process()
                    } label: {
                        if visionDetector.isBodyPoseRequired {
                            Text("Hide Body Pose")
                        } else {
                            Text("Show Body Pose")
                        }
                    }.padding()
                    
                    Button {
                        visionDetector.isHandPoseRequired.toggle()
                        visionDetector.process()
                    } label: {
                        if visionDetector.isHandPoseRequired {
                            Text("Hide Hand Pose")
                        } else {
                            Text("Show Hand Pose")
                        }
                    }.padding()
                    
                    Button {
                        visionDetector.isFaceLandmarksRequired.toggle()
                        visionDetector.process()
                    } label: {
                        if visionDetector.isBodyPoseRequired {
                            Text("Hide Face Landmarks")
                        } else {
                            Text("Show Face Landmarks")
                        }
                    }.padding()
                    
                } else {
                    Image("background")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height:geometry.size.height/2)
                    Button(action: {
                        isShowingImagePicker.toggle()
                    }, label: {
                        Text("Fetch from Camera")
                    }).padding()
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(image: $visionDetector.selectedImage)
                    }
                }
            }.ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
