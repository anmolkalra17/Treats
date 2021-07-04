//
//  HomeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	var recipes = [RecipeData]()
	var recipeImageData = [String: Data]()
	
	override func viewWillAppear(_ animated: Bool) {
		let search = "pasta"
		let maxFat = "25"
		let number = "1"
		
		SearchManager.instance.getRecipeData(for: search, maxFat: maxFat, numberOfResults: number) { response in
			print(response)
			self.recipes = response.results.map({ value in
				RecipeData(vegetarian: value.vegetarian, readyInMinutes: value.readyInMinutes, servings: value.servings, title: value.title, image: value.image, summary: value.summary)
			})
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		print(recipes.count)
	}
	
	func setupView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		title = "Treats"
		navigationController?.navigationBar.prefersLargeTitles = true
		collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "recipeCell")
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
		cell.readyInLabel.text = String(recipe.readyInMinutes)
		cell.servingsLabel.text = String(recipe.servings)
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
	
	func getImageForCell(using url: URL, completion: @escaping(Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let safeData = data else { return }
			completion(safeData)
		}.resume()
	}
}
