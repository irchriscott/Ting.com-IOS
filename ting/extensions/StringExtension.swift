//
//  StringExtension.swift
//  ting
//
//  Created by Christian Scott on 07/11/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit
import Atributika

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
    
    func size(font: UIFont, width: CGFloat) -> CGSize {
        let attrString: NSAttributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        let bounds: CGRect = attrString.boundingRect(with: CGSize(width: width, height: 0.0), options: .usesLineFragmentOrigin, context: nil)
        let size: CGSize = CGSize(width: bounds.width + 1, height: bounds.height + 2 * (font.lineHeight - font.pointSize))
        return size
    }
    
    func getSize(font: UIFont, width: CGFloat) -> CGSize {
        let string = NSString(string: self).boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : font], context: nil)
        return CGSize(width: string.width, height: string.height)
    }
    
    func stringWithIndentedList() -> NSAttributedString {
        let bullet = "• "
        let transformers: [TagTransformer] = [
            TagTransformer.brTransformer,
            TagTransformer(tagName: "li", tagType: .start, replaceValue: bullet),
            TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
        ]

        let listItemFont = UIFont(name: "Poppins-Regular", size: 13.0)!
        let indentation: CGFloat = (bullet as NSString).size(withAttributes: [NSAttributedString.Key.font: listItemFont]).width

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentation, options: [NSTextTab.OptionKey: Any]())]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.headIndent = indentation

        let li = Style("li")
            .font(listItemFont)
            .paragraphStyle(paragraphStyle)

        return self.style(tags: li, transformers: transformers)
            .styleAll(Style.font(UIFont(name: "Poppins-Regular", size: 13.0)!).foregroundColor(Colors.colorGray))
            .attributedString
    }
}
