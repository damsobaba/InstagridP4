//
//  UIView+image.swift
//  InstagrigP4
//
//  Created by Adam Mabrouki on 08/04/2020.
//  Copyright © 2020 Adam Mabrouki. All rights reserved.
//

import UIKit
/// enable to change all the mainview into one image 
extension UIView {
    var asImage: UIImage {
       let renderer = UIGraphicsImageRenderer(bounds: bounds)
       return renderer.image { rendererContext in
           layer.render(in: rendererContext.cgContext)
       }
   }
    
}
