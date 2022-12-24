//
//  HomeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var spinner: UIImageView! {
		didSet {
			spinner.image = UIImage(named: "pizza_loader.png")
		}
	}
	
	let K = Constants()
	let viewModel = HomeViewModel()
	
	var recipes = [Results]() {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.number = "10"
		viewModel.searchManager.getRecipeData(for: viewModel.food.randomElement()!, numberOfResults: viewModel.number) { response in
			self.recipes = response
			DispatchQueue.main.async { [weak self] in
				self?.stopAnimation()
				self?.collectionView.isHidden = false
			}
		}
		setupViews()
	}
	
	func setupViews() {
		startAnimation()
		collectionView.isHidden = true
		collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: K.collectionCellID)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		searchBar.delegate = self
		searchBar.isTranslucent = false
		view.addSubview(collectionView)
		
		title = "Treats"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.backButtonTitle = "Back"
		navigationController?.navigationBar.isTranslucent = true
	}
	
	func startAnimation() {
		spinner.isHidden = false
		if viewModel.timer == nil {
			viewModel.timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animateView), userInfo: nil, repeats: false)
		}
	}
	
	@objc func animateView() {
		UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveLinear, animations: {
			self.spinner.transform = self.spinner.transform.rotated(by: CGFloat(Double.pi))
		}, completion: { (finished) in
			if self.viewModel.timer != nil {
				self.viewModel.timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animateView), userInfo: nil, repeats: false)
			}
		})
	}
	
	func stopAnimation() {
		viewModel.timer?.invalidate()
		collectionView.isHidden = false
		viewModel.timer = nil
		spinner.isHidden = true
	}
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recipes.count
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		searchBar.resignFirstResponder()
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
		
		if viewModel.recipeImageData[recipe.image] == nil {
			guard let imageURL = URL(string: recipe.image) else { return cell }
//			self.viewModel.getImageForCell(using: imageURL) { imageData in
//				self.viewModel.recipeImageData.updateValue(imageData, forKey: recipe.image)
//				DispatchQueue.main.async {
//					cell.imageView.image = UIImage(data: imageData)
//				}
//			}
			if #available(iOS 15.0, *) {
				Task.init {
					let imageData = await self.viewModel.getImageForCellAsync(using: imageURL)
					self.viewModel.recipeImageData.updateValue(imageData!, forKey: recipe.image)
					cell.imageView.image = UIImage(data: imageData!)
				}
			} else {
				// Fallback on earlier versions
			}
		} else {
			DispatchQueue.main.async {
				cell.imageView.image = UIImage(data: self.viewModel.recipeImageData[recipe.image]!)
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let recipeController = storyboard?.instantiateViewController(withIdentifier: "Recipe") as? RecipeViewController else { return }
		recipeController.title = recipes[indexPath.row].title
		recipeController.imageData = viewModel.recipeImageData[recipes[indexPath.row].image]
		recipeController.recipes = recipes[indexPath.row]
		recipeController.index = indexPath.row
		navigationController?.pushViewController(recipeController, animated: true)
	}
}

extension HomeViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if searchBar.text == "" {
			searchBar.resignFirstResponder()
		} else {
			recipes = []
			viewModel.recipeImageData = [:]
			DispatchQueue.main.async { [weak self] in
				self?.startAnimation()
				self?.collectionView.isHidden = true
			}
			viewModel.timer2 = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(callAPI), userInfo: nil, repeats: false)
			searchBar.resignFirstResponder()
		}
	}
	
	@objc func callAPI() {
		let searchString = searchBar.text!
		self.viewModel.searchManager.getRecipeData(for: searchString, numberOfResults: "10") { response in
			if response.isEmpty {
				DispatchQueue.main.async { [weak self] in
					self?.viewModel.handleError(for: searchString, viewController: self!)
					self?.searchBar.text = ""
					self?.stopAnimation()
				}
			} else {
				self.recipes = response
				DispatchQueue.main.async { [weak self] in
					self?.stopAnimation()
					self?.collectionView.isHidden = false
				}
			}
		}
		viewModel.timer2?.invalidate()
	}
}
