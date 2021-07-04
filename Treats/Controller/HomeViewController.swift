//
//  HomeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class HomeViewController: UIViewController {
	
	var collectionView: UICollectionView!
	var recipes = [Results]()
	var recipeImageData = [String: Data]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let search = "pasta"
		let maxFat = "25"
		let number = "1"
		
		SearchManager.instance.getRecipeData(for: search, maxFat: maxFat, numberOfResults: number) { response in
			self.recipes = response.results
		}
		setupViews()
	}
	
	func setupViews() {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 8
		layout.minimumInteritemSpacing = 8
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "recipeCell")
		collectionView.backgroundColor = .green
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		view.addSubview(collectionView)
		
		title = "Treats"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
			collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
		])
	}
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recipes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.size.width, height: 300)
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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let recipeController = RecipeViewController()
		recipeController.title = recipes[indexPath.row].title
		present(recipeController, animated: true, completion: nil)
	}
	
	func getImageForCell(using url: URL, completion: @escaping(Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let safeData = data else { return }
			completion(safeData)
		}.resume()
	}
}
