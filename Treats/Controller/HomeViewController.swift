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
	let K = Constants()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let search = "soup"
//		let maxFat = "15"
//		let number = "10"
//
//		searchManager.getRecipeData(for: search, maxFat: maxFat, numberOfResults: number) { response in
//			self.recipes = response
//		}
		
		// Mock call: Remove later
		self.recipes = searchManager.getDataFromFile()!
		setupViews()
	}
	
	func setupViews() {
		collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: K.collectionCellID)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor(named: K.background)
		view.backgroundColor = UIColor(named: K.background)
		view.addSubview(collectionView)
		
		title = "Treats"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.backButtonTitle = "Back"
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.navigationBar.backgroundColor = UIColor(named: K.background)
	}
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recipes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.size.width, height: 350)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.collectionCellID, for: indexPath) as! RecipeCell
		let recipe = recipes[indexPath.row]
		cell.recipeLabel.text = recipe.title.capitalized
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
		guard let recipeController = storyboard?.instantiateViewController(withIdentifier: "Recipe") as? RecipeViewController else { return }
		recipeController.title = recipes[indexPath.row].title
		recipeController.imageData = recipeImageData[recipes[indexPath.row].image]
		recipeController.recipes = recipes[indexPath.row]
		recipeController.index = indexPath.row
		navigationController?.pushViewController(recipeController, animated: true)
	}
	
	func getImageForCell(using url: URL, completion: @escaping(Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let safeData = data else { return }
			completion(safeData)
		}.resume()
	}
}
