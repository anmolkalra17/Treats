//
//  HomeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		title = "Recipes"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let search = "pasta"
		let maxFat = "25"
		let number = "2"
		
		SearchManager.instance.getRecipeData(for: search, maxFat: maxFat, numberOfResults: number) { response in
			print(response)
		}
	}
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		<#code#>
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		<#code#>
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		<#code#>
	}
}
