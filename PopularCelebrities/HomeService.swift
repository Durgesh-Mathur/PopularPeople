//
//  HomeService.swift
//  PopularCelebrities
//
//  Created by Durgesh Mathur on 24/12/24.
//

import Foundation

class HomeCoreService : OACoreServiceProtocol {
    
    private var networkService: OANetworkServiceProtocol
    init(networkService: OANetworkServiceProtocol = OANetworkService()) {
        self.networkService = networkService
        
    }
    
    func fetchPopular(pageNumber: Int) async throws -> PopularListModel? {
        let endpoint = OAEndpoint.initializeToken
        do {
            return try await networkService.sendRequest(endpoint: endpoint)
        } catch {
            //              endpoint.logError(error: error)
            throw error
        }
    }

}
