//
//  NutrientsViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 05/07/21.
//

import UIKit

class NutrientsViewController: UITableViewController {
	
	let K = Constants()
	var recipe: Results?
	var nutritionData: NutritionData? {
		didSet {
			DispatchQueue.main.async { [weak self] in
				self?.tableView.reloadData()
			}
		}
	}
	
	var vegan: Bool?
	var glutenFree: Bool?
	var dairyFree: Bool?
	var veryHealthy: Bool?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
	}
	
	func setupView() {
		navigationItem.backButtonTitle = "Recipe"
		navigationItem.title = "Nutritional Information"
		tableView.rowHeight = 70
	}

	func setTintColor(for value: Bool) -> UIColor {
		if value {
			return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
		}
		return #colorLiteral(red: 0.937254902, green: 0.2117647059, blue: 0.2196078431, alpha: 1)
	}

	func setImageViewImage(for value: Bool) -> UIImage {
		if value {
			return UIImage(systemName: "checkmark.circle.fill")!
		}
		return UIImage(systemName: "xmark.circle.fill")!
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "nutrientsCell", for: indexPath)
		switch indexPath.row {
		case 0:
			cell.textLabel?.text = "Calories: \(nutritionData?.calories ?? 0) \(nutritionData?.caloriesUnit ?? "")"
			cell.imageView?.image = UIImage(named: "calories.png")
		case 1:
			cell.textLabel?.text = "Fat: \(nutritionData?.fat ?? 0) \(nutritionData?.fatUnit ?? "")"
			cell.imageView?.image = UIImage(named: "fat.png")
		case 2:
			cell.textLabel?.text = "Carbohydrates: \(nutritionData?.carbs ?? 0) \(nutritionData?.carbsUnit ?? "")"
			cell.imageView?.image = UIImage(named: "carbs.png")
		case 3:
			cell.textLabel?.text = "Protein: \(nutritionData?.protein ?? 0) \(nutritionData?.protienUnit ?? "")"
			cell.imageView?.image = UIImage(named: "protein.png")
		case 4:
			cell.textLabel?.text = "Vegan"
			cell.imageView?.image = setImageViewImage(for: vegan!)
			cell.imageView?.tintColor = setTintColor(for: vegan!)
		case 5:
			cell.textLabel?.text = "Gluten Free"
			cell.imageView?.image = setImageViewImage(for: glutenFree!)
			cell.imageView?.tintColor = setTintColor(for: glutenFree!)
		case 6:
			cell.textLabel?.text = "Dairy Free"
			cell.imageView?.image = setImageViewImage(for: dairyFree!)
			cell.imageView?.tintColor = setTintColor(for: dairyFree!)
		case 7:
			cell.textLabel?.text = "Very Healthy"
			cell.imageView?.image = setImageViewImage(for: veryHealthy!)
			cell.imageView?.tintColor = setTintColor(for: veryHealthy!)
		default:
			cell.textLabel?.text = ""
			cell.imageView?.image = nil
		}
		return cell
	}	
}
