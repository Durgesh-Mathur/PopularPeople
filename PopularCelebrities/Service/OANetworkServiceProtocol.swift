
import Foundation
protocol OANetworkServiceProtocol {
    func sendRequest<T: Decodable>(endpoint: OAEndpoint) async throws -> T
}

