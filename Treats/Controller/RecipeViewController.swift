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
		title = recipes?.title.capitalized
		navigationItem.backButtonTitle = "Recipe"
		let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showNutrientsInfo))
		let shareRecipeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareRecipe))
		navigationItem.rightBarButtonItems = [shareRecipeButton, infoButton]
		
		view.backgroundColor = UIColor(named: K.background)
		imageView.image = UIImage(data: imageData!)
		imageView.layer.cornerRadius = 16
		imageView.contentMode = .scaleToFill
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
		nutrientsVC.dairyFree = recipes?.dairyFree
		nutrientsVC.vegan = recipes?.vegan
		nutrientsVC.glutenFree = recipes?.glutenFree
		nutrientsVC.veryHealthy = recipes?.veryHealthy
		nutrientsVC.recipeName = recipes?.title
		navigationController?.pushViewController(nutrientsVC, animated: true)
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
}
