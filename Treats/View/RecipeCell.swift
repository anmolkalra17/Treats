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
		someView.layer.cornerRadius = 16
		someView.translatesAutoresizingMaskIntoConstraints = false
		someView.backgroundColor = .white
		someView.layer.borderWidth = 0.5
		someView.layer.borderColor = UIColor.black.cgColor
		return someView
	}()
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 16
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	let recipeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 16)
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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupViews() {
		addSubview(mainView)
		mainView.addSubview(imageView)
		mainView.addSubview(recipeLabel)
		mainView.addSubview(vegetarianImageView)
		mainView.addSubview(readyInLabel)
		mainView.addSubview(servingsLabel)
		
		NSLayoutConstraint.activate([
			mainView.heightAnchor.constraint(equalToConstant: 300),
			
			imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: mainView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -48),
			
			recipeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
			recipeLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
			
			vegetarianImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
			vegetarianImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
			vegetarianImageView.widthAnchor.constraint(equalToConstant: 30),
			vegetarianImageView.heightAnchor.constraint(equalToConstant: 30),
			
			readyInLabel.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 8),
			readyInLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
			
			servingsLabel.topAnchor.constraint(equalTo: readyInLabel.bottomAnchor, constant: 8),
			servingsLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8)
			
		])
	}
}
