//
//  StringExtension.swift
//  ting
//
//  Created by Christian Scott on 07/11/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let _ = [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 13.0)!, NSAttributedString.Key.foregroundColor: Colors.colorGray]
        return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                            .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let _ = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }

        return self.replacingOccurrences(of: "<[^>]+>", with: ", ", options: .regularExpression, range: nil).replacingOccurrences(of: ",,", with: ",")
    }
}
