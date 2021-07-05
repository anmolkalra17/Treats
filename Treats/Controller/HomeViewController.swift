//
//  HomeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	var recipes = [Results]() {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	var recipeImageData = [String: Data]()
	let searchManager = SearchManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let search = "soup"
//		let maxFat = "15"
//		let number = "10"
//
//		searchManager.getRecipeData(for: search, maxFat: maxFat, numberOfResults: number) { response in
//			self.recipes = response
//		}
		self.recipes = searchManager.getDataFromFile()!
		setupViews()
	}
	
	func setupViews() {
		collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "recipeCell")
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9607843137, blue: 0.9411764706, alpha: 1)
		view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9607843137, blue: 0.9411764706, alpha: 1)
		view.addSubview(collectionView)
		
		title = "Treats"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.backButtonTitle = "Back"
		navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9607843137, blue: 0.9411764706, alpha: 1)
	}
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recipes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCell
		let recipe = recipes[indexPath.row]
		cell.recipeLabel.text = recipe.title
		cell.readyInLabel.text = "Ready In: \(String(recipe.readyInMinutes)) minutes"
		cell.servingsLabel.text = "Serves: \(String(recipe.servings))"
		cell.vegetarianImageView.image = UIImage(named: recipe.vegetarian ? "veg" : "non-veg")
		
		if recipeImageData[recipe.image] == nil {
			guard let imageURL = URL(string: recipe.image) else { return cell }
			self.getImageForCell(using: imageURL) { imageData in
				self.recipeImageData.updateValue(imageData, forKey: recipe.image)
				DispatchQueue.main.async {
					cell.imageView.image = UIImage(data: imageData)
				}
			}
		} else {
			DispatchQueue.main.async {
				cell.imageView.image = UIImage(data: self.recipeImageData[recipe.image]!)
			}
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let recipeController = RecipeViewController()
		recipeController.title = recipes[indexPath.row].title
		navigationController?.pushViewController(recipeController, animated: true)
	}
	
	func getImageForCell(using url: URL, completion: @escaping(Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let safeData = data else { return }
			completion(safeData)
		}.resume()
	}
}
