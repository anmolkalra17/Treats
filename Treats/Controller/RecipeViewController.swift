//
//  RecipeViewController.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import UIKit

class RecipeViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var readyInTextLabel: UILabel!
	@IBOutlet weak var servesPeopleLabel: UILabel!
	@IBOutlet weak var foodTypeImage: UIImageView!
	@IBOutlet weak var stepsTextView: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .green
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.backButtonTitle = "Back"
    }
}
