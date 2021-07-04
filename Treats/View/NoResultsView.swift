//
//  NoResultsView.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class NoResultsView: UIView {
	let mainLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 32)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let messageLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		self.addSubview(mainLabel)
		self.addSubview(messageLabel)
		
		NSLayoutConstraint.activate([
			
			self.heightAnchor.constraint(equalToConstant: 300),
			mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			mainLabel.topAnchor.constraint(equalTo: self.topAnchor)
		])
	}
}
