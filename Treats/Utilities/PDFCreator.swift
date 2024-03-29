//
//  PDFCreator.swift
//  Treats
//
//  Created by Anmol Kalra on 08/07/21.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
	
	let title: String
	let body: String
	let image: UIImage
	let vegetarian: Bool
	
	init(title: String, body: String, image: UIImage, vegetarian: Bool) {
		self.title = title
		self.body = body
		self.image = image
		self.vegetarian = vegetarian
	}
	
	func createFlyer() -> Data {
		let pdfMetaData = [
			kCGPDFContextCreator: "Treats",
			kCGPDFContextAuthor: "Treats App",
			kCGPDFContextTitle: "\(title) (\(vegetarian ? "Veg." : "Non-Veg."))"
		]
		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = pdfMetaData as [String: Any]
		
		let pageWidth = 8.5 * 72.0
		let pageHeight = 12 * 72.0
		let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
		
		let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
		let data = renderer.pdfData { (context) in
			context.beginPage()
			let titleBottom = addTitle(pageRect: pageRect)
			let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
			addBodyText(pageRect: pageRect, textTop: imageBottom + 24.0)
		}
		return data
	}
	
	func addTitle(pageRect: CGRect) -> CGFloat {
		let titleFont = UIFont.systemFont(ofSize: 16.0, weight: .bold)
		let titleAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: titleFont,
			NSAttributedString.Key.underlineColor: UIColor.black,
			NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
		]
		let attributedTitle = NSAttributedString(
			string: "\(title) (\(vegetarian ? "Veg." : "Non-Veg."))",
			attributes: titleAttributes
		)
		let titleStringSize = attributedTitle.size()
		let titleStringRect = CGRect(
			x: (pageRect.width - titleStringSize.width) / 2.0,
			y: 32,
			width: titleStringSize.width,
			height: titleStringSize.height
		)
		attributedTitle.draw(in: titleStringRect)
		return titleStringRect.origin.y + titleStringRect.size.height
	}
	
	func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
		let maxHeight = pageRect.height * 0.40
		let maxWidth = pageRect.width * 0.60
		let aspectWidth = maxWidth / image.size.width
		let aspectHeight = maxHeight / image.size.height
		let aspectRatio = min(aspectWidth, aspectHeight)
		let scaledWidth = image.size.width * aspectRatio
		let scaledHeight = image.size.height * aspectRatio
		let imageX = (pageRect.width - scaledWidth) / 2.0
		let imageRect = CGRect(x: imageX, y: imageTop,
							   width: scaledWidth, height: scaledHeight)
		image.draw(in: imageRect)
		return imageRect.origin.y + imageRect.size.height
	}
	
	func addBodyText(pageRect: CGRect, textTop: CGFloat) {
		let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .justified
		let textAttributes = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
			NSAttributedString.Key.font: textFont
		]
		let attributedText = NSAttributedString(
			string: body,
			attributes: textAttributes
		)
		let textRect = CGRect(
			x: 20,
			y: textTop,
			width: pageRect.width - 40,
			height: pageRect.height - textTop
		)
		attributedText.draw(in: textRect)
	}
}
