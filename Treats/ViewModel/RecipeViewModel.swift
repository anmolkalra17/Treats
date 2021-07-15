//
//  RecipeViewModel.swift
//  Treats
//
//  Created by Anmol Kalra on 08/07/21.
//

import Foundation
import UIKit

class RecipeViewModel {
	
	let searchManager = SearchManager()
	
	func handleError(for viewController: UIViewController) {
		let ac = UIAlertController(title: "Error", message: "Could not find nutritional data.", preferredStyle: .alert)
		let okay = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		ac.addAction(okay)
		viewController.present(ac, animated: true, completion: nil)
	}
}
