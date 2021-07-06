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
		someView.layer.shadowRadius = 0.5
		someView.layer.shadowOffset = CGSize(width: 3, height: 3)
		someView.layer.shadowColor = UIColor.gray.cgColor
		someView.layer.shadowOpacity = 0.3
		someView.backgroundColor = UIColor(named: "backgroundColorGlobal")
		return someView
	}()
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleToFill
		imageView.layer.cornerRadius = 16
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	let recipeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textColor = UIColor(named: "textColorGlobal")
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
		label.textColor = UIColor(named: "textColorGlobal")
		return label
	}()

	let servingsLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = UIColor(named: "textColorGlobal")
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
			mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
			mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
			mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
			
			imageView.topAnchor.constraint(equalTo: mainView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
			
			recipeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
			recipeLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
			
			vegetarianImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
			vegetarianImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
			vegetarianImageView.widthAnchor.constraint(equalToConstant: 30),
			vegetarianImageView.heightAnchor.constraint(equalToConstant: 30),
			
			readyInLabel.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 8),
			readyInLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
			
			servingsLabel.topAnchor.constraint(equalTo: readyInLabel.bottomAnchor, constant: 8),
			servingsLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
			servingsLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8)
		])
	}
}
