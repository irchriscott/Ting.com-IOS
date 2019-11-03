//
//  Media.swift
//  ting
//
//  Created by Ir Christian Scott on 04/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init? (withImage image: UIImage, forKey key: String){
        self.key = key
        self.mimeType = "image/png"
        self.filename = "image_\(arc4random()).png"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
