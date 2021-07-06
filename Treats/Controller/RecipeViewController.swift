//
//  RecipeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class RecipeViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var readyInTextLabel: UILabel!
	@IBOutlet weak var servesPeopleLabel: UILabel!
	@IBOutlet weak var foodTypeImage: UIImageView!
	@IBOutlet weak var stepsTextView: UITextView!
	
	var recipes: Results?
	var index: Int?
	var imageData: Data?
	let K = Constants()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
	}
	
	func setupView() {
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.backButtonTitle = "Back"
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showNutrientsInfo))
		
		view.backgroundColor = UIColor(named: K.background)
		imageView.image = UIImage(data: imageData!)
		readyInTextLabel.text = "⏳ \(String(recipes!.readyInMinutes)) mintues"
		readyInTextLabel.textColor = UIColor(named: K.fontColor)
		servesPeopleLabel.text = "Serves: \(String(recipes!.servings)) people"
		servesPeopleLabel.textColor = UIColor(named: K.fontColor)
		foodTypeImage.image = UIImage(named: recipes!.vegetarian ? "veg" : "non-veg")
		
		stepsTextView.textAlignment = .justified
		stepsTextView.text = setupRecipeSteps(using: recipes!)
		stepsTextView.backgroundColor = UIColor(named: K.background)
		stepsTextView.textColor = UIColor(named: K.fontColor)
		stepsTextView.isEditable = false
		stepsTextView.isSelectable = false
	}
	
	@objc func showNutrientsInfo() {
		guard let nutrientsVC = storyboard?.instantiateViewController(withIdentifier: "Nutrients") as? NutrientsViewController else { return }
		present(nutrientsVC, animated: true, completion: nil)
	}
	
	func setupRecipeSteps(using recipe: Results) -> String? {
		var recipeSteps = RecipeSteps(recipe: recipe)
		var finalStep = ""
		
		for i in 0...recipe.analyzedInstructions.first!.steps.count - 1 {
//			let equipmentName = recipe.analyzedInstructions.first?.steps[i].equipment[i].name
//			let ingredientName = recipe.analyzedInstructions.first?.steps[i].ingredients[i].name
			let step = recipe.analyzedInstructions.first?.steps[i].step
			
//			recipeSteps.equipments.append(equipmentName ?? "")
//			recipeSteps.ingredients.append(ingredientName ?? "")
			
			recipeSteps.stepsToFollow.updateValue(step ?? "" + "\n" , forKey: i + 1)
		}
		
		for i in 0...recipeSteps.stepsToFollow.count - 1 {
			guard let step = recipeSteps.stepsToFollow[i + 1] else { return nil }
			finalStep += "Step \(i + 1): \(step) \n \n"
		}
		return finalStep
	}
}
