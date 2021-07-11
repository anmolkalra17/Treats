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
	
	let searchManager = SearchManager()
	let K = Constants()
	
	var recipes = [Results]() {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	var recipeImageData = [String: Data]()
	var timer: Timer?
	var timer2: Timer?
	var search: String?
	var number: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		search = "soup"
		number = "10"

		searchManager.getRecipeData(for: search!, numberOfResults: number) { response in
			self.recipes = response
			DispatchQueue.main.async { [weak self] in
				self?.stopAnimation()
				self?.collectionView.isHidden = false
			}
		}
		
//	    Mock call: Remove later
//		searchManager.getDataFromFile { response in
//			self.recipes = response
//			DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//				self?.stopAnimation()
//				self?.collectionView.isHidden = false
//			}
//		}
		setupViews()
	}
	
	func setupViews() {
		startAnimation()
		collectionView.isHidden = true
		collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: K.collectionCellID)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor(named: K.background)
		searchBar.delegate = self
		searchBar.isTranslucent = false
		view.backgroundColor = UIColor(named: K.background)
		view.addSubview(collectionView)
		
		title = "Treats"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.backButtonTitle = "Back"
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.navigationBar.backgroundColor = UIColor(named: K.navBarColor)
	}
	
	func startAnimation() {
		spinner.isHidden = false
		if timer == nil {
			timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animateView), userInfo: nil, repeats: false)
		}
	}
	
	@objc func animateView() {
		UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveLinear, animations: {
			self.spinner.transform = self.spinner.transform.rotated(by: CGFloat(Double.pi))
		}, completion: { (finished) in
			if self.timer != nil {
				self.timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animateView), userInfo: nil, repeats: false)
			}
		})
	}
	
	func stopAnimation() {
		timer?.invalidate()
		collectionView.isHidden = false
		timer = nil
		spinner.isHidden = true
	}
	
	func handleError() {
		let ac = UIAlertController(title: "Error", message: "Could not fetch data from server.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		present(ac, animated: true, completion: nil)
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

extension HomeViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if searchBar.text == "" {
			searchBar.resignFirstResponder()
		} else {
			recipes = []
			recipeImageData = [:]
			DispatchQueue.main.async { [weak self] in
				self?.startAnimation()
				self?.collectionView.isHidden = true
			}
			timer2 = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(callAPI), userInfo: nil, repeats: false)
			searchBar.resignFirstResponder()
		}
	}
	
	@objc func callAPI() {
		let searchString = searchBar.text!
		self.searchManager.getRecipeData(for: searchString, numberOfResults: "10") { response in
			if response.isEmpty {
				DispatchQueue.main.async { [weak self] in
					self?.handleError()
					self?.searchBar.text = ""
					self?.stopAnimation()
				}
			} else {
				self.recipes = response
				DispatchQueue.main.async { [weak self] in
					self?.searchBar.text = ""
					self?.stopAnimation()
					self?.collectionView.isHidden = false
				}
	//			Mock Call
	//			self?.searchManager.getDataFromFile(completion: { response in
	//				self?.recipes = response
	//				DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
	//					self?.stopAnimation()
	//					self?.collectionView.isHidden = false
	//				}
	//			})
			}
		}
		timer2?.invalidate()
	}
}
