//
//  RecipeModel.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import Foundation

struct RecipeModel: Decodable {
	let results: [Results]
}

struct Results: Decodable {
	let vegetarian: Bool
	let readyInMinutes: Int
	let servings: Int
	let title: String
	let image: String
	let summary: String
	let nutrition: Nutrition
	let analyzedInstructions: [AnalyzedInstruction]
}

struct Nutrition: Decodable {
	let nutrients: [Nutrient]
}

struct Nutrient: Decodable {
	let title: String
	let name: String
	let amount: Double
	let unit: String
}

struct AnalyzedInstruction: Decodable {
	let name: String
	let steps: [Step]
}

struct Step: Decodable {
	let number: Int
	let step: String
	let ingredients, equipment: [Ent]
	let length: Length?
}

struct Ent: Decodable {
	let name: String
}

struct Length: Decodable {
	let number: Int
	let unit: String
}
