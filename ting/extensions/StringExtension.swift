//
//  StringExtension.swift
//  ting
//
//  Created by Christian Scott on 07/11/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

extension String {
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
        return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}
