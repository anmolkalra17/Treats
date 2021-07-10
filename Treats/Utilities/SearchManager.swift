//
//  SearchManager.swift
//  Treats
//
//  Created by Anmol Kalra on 04/07/21.
//

import Foundation

class SearchManager {
	
	let K = Constants()
	static let instance = SearchManager()
	
	func createURL(for searchString: String, number: String?) -> URL {
		var components = URLComponents()
		components.scheme = K.scheme
		components.host = K.host
		components.path = K.path
		components.queryItems = [
			URLQueryItem(name: "apiKey", value: K.apiKey),
			URLQueryItem(name: "query", value: searchString),
			URLQueryItem(name: "number", value: number ?? ""),
			URLQueryItem(name: "addRecipeInformation", value: "true")
		]
		
		guard let url = components.url else { fatalError("Could not create URL.") }
		print(url)
		return url
	}
	
	func createNutritionURL(for recipeName: String) -> URL {
		var components = URLComponents()
		components.scheme = K.scheme
		components.host = K.host
		components.path = K.nutritionPath
		
		let searchString = recipeName.replacingOccurrences(of: " ", with: "+")
		components.queryItems = [
			URLQueryItem(name: "apiKey", value: K.apiKey),
			URLQueryItem(name: "title", value: searchString)
		]
		
		guard let url = components.url else { fatalError("Could not create nutrition URL.") }
		print(url)
		return url
	}
	
	func getRecipeData(for food: String, numberOfResults: String?, completion: @escaping ([Results]) -> Void) {
		let url = createURL(for: food, number: numberOfResults ?? "")
		let session = URLSession.shared
		session.dataTask(with: url) { data, response, error in
			if let e = error {
				print(e)
			}
			
			if let safeData = data {
				let response = self.parseJSON(for: safeData)
				completion(response)
			}
		}.resume()
	}
	
	func parseJSON(for data: Data) -> [Results] {
		var response: RecipeModel?
		do {
			response = try JSONDecoder().decode(RecipeModel.self, from: data)
		} catch {
			print(error)
		}
		guard let safeData = response else { fatalError("Could not parse data.") }
		return safeData.results
	}
	
	//	Getting nutrition data
	
	func getNutritionData(for recipeName: String, completion: @escaping (NutritionModel?) -> Void) {
		let url = createNutritionURL(for: recipeName)
		let session = URLSession.shared
		session.dataTask(with: url) { data, response, error in
			if let e = error {
				print(e)
			}
			
			if let safeData = data {
				if let nutritionInfo = self.parseNutritionJSON(using: safeData) {
					completion(nutritionInfo)
				}
			}
		}.resume()
	}
	
	func parseNutritionJSON(using data: Data) -> NutritionModel? {
		do {
			if let nutritonData = try? JSONDecoder().decode(NutritionModel.self, from: data) {
				return nutritonData
			}
		}
		return nil
	}
	
	// Use when API call limit exceeds (mock method calls using local json from app bundle)
	
	func getDataFromFile(completion: @escaping ([Results]) -> Void) {
		if let path = Bundle.main.url(forResource: "test", withExtension: "json") {
			do {
				let response = try String(contentsOf: path).data(using: .utf8)
				guard let results = parseJSONFromFile(using: response!) else { return }
				completion(results)
			} catch {
				print(error)
			}
		}
	}
	
	func parseJSONFromFile(using data: Data) -> [Results]? {
		do {
			let decodedData = try JSONDecoder().decode(RecipeModel.self, from: data)
			return decodedData.results
		} catch {
			print(error)
		}
		return nil
	}
	
	func getNutritionDataFromFile() -> NutritionModel? {
		if let path = Bundle.main.url(forResource: "nutrition", withExtension: "json") {
			do {
				let response = try String(contentsOf: path).data(using: .utf8)
				let results = parseNutritionFromFile(using: response!)
				return results
			} catch {
				print(error)
			}
		}
		return nil
	}
	
	func parseNutritionFromFile(using data: Data) -> NutritionModel? {
		do {
			let decodedData = try JSONDecoder().decode(NutritionModel.self, from: data)
			return decodedData
		} catch {
			print(error)
		}
		return nil
	}
}
