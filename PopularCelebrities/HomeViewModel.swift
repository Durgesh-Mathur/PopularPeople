//
//  HomeViewModel.swift
//  PopularCelebrities
//
//  Created by Durgesh Mathur on 24/12/24.
//

import Foundation


class OAHomeScreenViewModel {
 
    private let coreService: OACoreServiceProtocol

     
    var listOfPeople: [Result] = []
    var currentPage = 0
    init(coreService: OACoreServiceProtocol = HomeCoreService()) {
        self.coreService = coreService
    }
    
    // Fetch data on appear
    func fetchHomeData(completion: () -> ()) async {
        do {
            let homeData = try await coreService.fetchPopular(pageNumber: currentPage + 1)
            print(homeData)
            listOfPeople.append(contentsOf: homeData?.results ?? [])
            completion()
        } catch {
            currentPage = currentPage - 1
            if (error as? URLError)?.code != .cancelled {
                print("Failed to fetch data: \(error.localizedDescription)")
            }
        }

    }
    
//    let url = URL(string: "https://api.themoviedb.org/3/trending/person/day?language=en-US")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET" // or "POST", "PUT", etc.
//
//    // Add headers
//    request.setValue("application/json", forHTTPHeaderField: "accept")
//    request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZWQwYjQxMTUyNDFlNmRmZTc5ZDU3MGMwYzQ4N2E4MiIsIm5iZiI6MTczNTAyNTQzNS4xNDQsInN1YiI6IjY3NmE2MzFiZmNjZTM5ZDllZTY0YTkzNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.xNo-S6lGKyhICPTtlPSphJuHjDKUJCMl6-PjcWL3eM8", forHTTPHeaderField: "Authorization")
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//            return
//        }
//        if let httpResponse = response as? HTTPURLResponse {
//            print("Status Code: \(httpResponse.statusCode)")
//        }
//        if let data = data {
//            do {
//                let decodedData = try JSONDecoder().decode(PopularListModel.self, from: data)
//
//                print("😇 Response Data: \(decodedData)")
//
//            } catch let DecodingError.dataCorrupted(context) {
//                print("Data corrupted: \(context)")
//            } catch let DecodingError.keyNotFound(key, context) {
//                print("Key '\(key)' not found: \(context.debugDescription)")
//                print("Coding Path: \(context.codingPath)")
//            } catch let DecodingError.valueNotFound(value, context) {
//                print("Value '\(value)' not found: \(context.debugDescription)")
//                print("Coding Path: \(context.codingPath)")
//            } catch let DecodingError.typeMismatch(type, context) {
//                print("Type '\(type)' mismatch: \(context.debugDescription)")
//                print("Coding Path: \(context.codingPath)")
//            } catch {
//                print("Decoding error: \(error.localizedDescription)")
//            }
//        }
//    }
//    task.resume()

    
}

