//
//  UNNotificaionAttachmentExtension.swift
//  ting
//
//  Created by Christian Scott on 08/10/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

extension UNNotificationAttachment {
    
    static func create(identifier: String, url: URL, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier + ".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    guard let imageData = image.pngData() else { return nil }
                    try! imageData.write(to: fileURL)
                    let attachment = try? UNNotificationAttachment(identifier: identifier, url: fileURL, options: options)
                    
                    return attachment
                }
            }
            
        } catch { return nil }
        
        return nil
    }
}
