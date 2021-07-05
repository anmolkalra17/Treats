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
	
	func createURL(for searchString: String, maxFat: String?, number: String?) -> URL {
		var components = URLComponents()
		components.scheme = K.scheme
		components.host = K.host
		components.path = K.path
		components.queryItems = [
			URLQueryItem(name: "apiKey", value: K.apiKey),
			URLQueryItem(name: "query", value: searchString),
			URLQueryItem(name: "maxFat", value: maxFat ?? ""),
			URLQueryItem(name: "number", value: number ?? ""),
			URLQueryItem(name: "addRecipeInformation", value: "true")
		]
		
		guard let url = components.url else { fatalError("Could not create URL.") }
		return url
	}
	
	func getRecipeData(for food: String, maxFat: String?, numberOfResults: String?, completion: @escaping ([Results]) -> Void) {
		let url = createURL(for: food, maxFat: maxFat ?? "", number: numberOfResults ?? "")
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
	// use when API call limit exhausts
	
	func getDataFromFile() -> [Results]? {
		if let path = Bundle.main.url(forResource: "test", withExtension: "json") {
			do {
				let response = try String(contentsOf: path).data(using: .utf8)
				let results = parseJSONFromFile(using: response!)
				return results
			} catch {
				print(error)
			}
		}
		return nil
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
}
