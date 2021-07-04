//
//  RecipeCell.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class RecipeCell: UICollectionViewCell {
	
	let mainView: UIView = {
		let someView = UIView()
		someView.backgroundColor = .green
		someView.translatesAutoresizingMaskIntoConstraints = false
		return someView
	}()
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	let recipeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 32)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let vegetarianImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	let readyInLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let servingsLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	func setupViews() {
		
	}
}
