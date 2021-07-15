//
//  RecipeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit
import PDFKit

class RecipeViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var readyInTextLabel: UILabel!
	@IBOutlet weak var servesPeopleLabel: UILabel!
	@IBOutlet weak var foodTypeImage: UIImageView!
	@IBOutlet weak var stepsTextView: UITextView!
	
	let viewModel = RecipeViewModel()
	var recipes: Results?
	var index: Int?
	var imageData: Data?
	let K = Constants()
	var nutritionData: NutritionData?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			self?.callAPI()
		}
	}
	
	func setupView() {
		navigationItem.largeTitleDisplayMode = .never
		title = recipes?.title.capitalized
		navigationItem.backButtonTitle = "Recipe"
		let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showNutrientsInfo))
		let shareRecipeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareRecipe))
		navigationItem.rightBarButtonItems = [shareRecipeButton, infoButton]
		
		imageView.image = UIImage(data: imageData!)
		imageView.layer.cornerRadius = 16
		imageView.contentMode = .scaleToFill
		readyInTextLabel.text = "⏳ \(String(recipes!.readyInMinutes)) mintues"
		servesPeopleLabel.text = "Serves: \(String(recipes!.servings)) people"
		foodTypeImage.image = UIImage(named: recipes!.vegetarian ? "veg" : "non-veg")
		
		stepsTextView.textAlignment = .justified
		stepsTextView.text = setupRecipeSteps(using: recipes!)
		stepsTextView.isEditable = false
		stepsTextView.isSelectable = false
	}
	
	@objc func showNutrientsInfo() {
		if nutritionData == nil {
			viewModel.handleError(for: self)
		} else {
			guard let nutrientsVC = storyboard?.instantiateViewController(withIdentifier: "Nutrients") as? NutrientsViewController else { return }
			nutrientsVC.dairyFree = recipes?.dairyFree
			nutrientsVC.vegan = recipes?.vegan
			nutrientsVC.glutenFree = recipes?.glutenFree
			nutrientsVC.veryHealthy = recipes?.veryHealthy
			nutrientsVC.nutritionData = self.nutritionData
			navigationController?.pushViewController(nutrientsVC, animated: true)
		}
	}
	
	@objc func shareRecipe() {
		print("share tapped")
		let shareString = "\(setupRecipeSteps(using: recipes!)!)"
		let shareImage = UIImage(data: imageData!)
		let pdfData = PDFCreator(title: recipes!.title.capitalized, body: shareString, image: shareImage!, vegetarian: recipes!.vegetarian)
		let pdf = pdfData.createFlyer()
		let shareAlert = UIActivityViewController(activityItems: [pdf], applicationActivities: [])
		present(shareAlert, animated: true, completion: nil)
	}
	
	func setupRecipeSteps(using recipe: Results) -> String? {
		var recipeSteps = RecipeSteps(recipe: recipe)
		var finalStep = ""
		
		guard let dataCount = recipe.analyzedInstructions.first?.steps.count else { return "Could not find recipe." }
		for i in 0...dataCount - 1 {
			let step = recipe.analyzedInstructions.first?.steps[i].step
			recipeSteps.stepsToFollow.updateValue(step ?? "" + "\n" , forKey: i + 1)
		}
		
		for i in 0...dataCount - 1 {
			guard let step = recipeSteps.stepsToFollow[i + 1] else { return nil }
			finalStep += "Step \(i + 1): \(step) \n \n"
		}
		return finalStep
	}
	
	func callAPI() {
		viewModel.searchManager.getNutritionData(for: recipes!.title) { response in
			self.nutritionData = NutritionData(calories: response!.calories.value, fat: response!.fat.value, protein: response!.protein.value, carbs: response!.carbs.value, caloriesUnit: response!.calories.unit, fatUnit: response!.fat.unit, protienUnit: response!.protein.unit, carbsUnit: response!.carbs.unit)
			print(self.nutritionData!)
		}
	}
}
