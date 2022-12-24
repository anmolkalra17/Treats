//
//  HomeViewModel.swift
//  Treats
//
//  Created by Anmol Kalra on 08/07/21.
//

import Foundation
import UIKit

enum MyError: Error {
	case dataNotFound
}

class HomeViewModel {
	let searchManager = SearchManager()
	
	let food = ["pizza", "soup", "milkshake", "burger"]
	
	var recipeImageData = [String: Data]()
	var timer: Timer?
	var timer2: Timer?
	var number: String?
	
	func getImageForCell(using url: URL, completion: @escaping(Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let safeData = data else { return }
			completion(safeData)
		}.resume()
	}
	
	@available(iOS 15.0.0, *)
	func getImageForCellAsync(using url: URL) async -> Data? {
		do {
			let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
			return data
		} catch {
			print(error)
			return nil
		}
	}
	
	func handleError(for searchTextString: String?, viewController: UIViewController) {
		let ac = UIAlertController(title: "Error", message: "Could not find results for \(searchTextString ?? ""). Try Again!", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		viewController.present(ac, animated: true, completion: nil)
	}
}
