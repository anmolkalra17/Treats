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
	let vegan: Bool
	let glutenFree: Bool
	let dairyFree: Bool
	let veryHealthy: Bool
	let analyzedInstructions: [AnalyzedInstruction]
}

struct AnalyzedInstruction: Decodable {
	let name: String
	let steps: [Step]
}

struct Step: Decodable {
	let number: Int
	let step: String
	let ingredients, equipment: [Ent]
}

struct Ent: Decodable {
	let name: String
}
