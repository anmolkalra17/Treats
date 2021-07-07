//
//  NutritionModel.swift
//  Treats
//
//  Created by Anmol Kalra on 06/07/21.
//

import Foundation

struct NutritionModel: Decodable {
	let calories: Calories
	let fat: Calories
	let protein: Calories
	let carbs: Calories
}

struct Calories: Decodable {
	let value: Int
	let unit: String
}
