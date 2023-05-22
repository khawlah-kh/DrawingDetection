//
//  ViewModel.swift
//  DrawingDetection
//
//  Created by Khawlah Khalid on 22/05/2023.
//

import SwiftUI
import CoreML


final class ViewModel: ObservableObject{
    @Published var result = ""
    @Published var drawing: UIImage?
    
    func classify(){
        guard let resizedImage = drawing?.resizeTo(size: CGSize(width: 299, height: 299)),
        let buffer = resizedImage.toBuffer()
        else {return}
        print("Detecting ....🧠")
        do{
        let model = try DrawingClassifier(configuration: .init())
            let predection = try model.prediction(image:buffer)
            self.result = predection.classLabel
        }
        catch{
            print("Error: \(error.localizedDescription)")
        }
    }
}
