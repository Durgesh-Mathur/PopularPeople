

import Foundation

enum OANetworkError : Error {
    case errorResponse(OAErrorResponse)
    case unknown
    
    var status: String? {
        return switch self {
        case .errorResponse(let errorResponse):
            errorResponse.status
        case .unknown: nil
            
        }
    }
    
    
    var header: String? {
        return switch self {
        case .errorResponse(let errorResponse):
            errorResponse.header
        case .unknown: nil
            
        }
    }
    
    var text: String? {
        return switch self {
        case .errorResponse(let errorResponse):
            errorResponse.text
        case .unknown: nil
            
        }
    }
    
    var reason: String? {
        return switch self {
        case .errorResponse(let errorResponse):
            errorResponse.reason
        case .unknown: nil
            
        }
    }
    
}

struct OAErrorResponse: Decodable {
    var status, reason, header, text: String?
    
    enum CodingKeys: String, CodingKey {
        case status, reason, header,text
    }
}

class OANetworkService: OANetworkServiceProtocol {

    func sendRequest<T: Decodable>(endpoint: OAEndpoint) async throws -> T {
        var attempts = 0
    
        
        while attempts < endpoint.retryCount {
            do {
                // Create the request
                var urlRequest = URLRequest(url: endpoint.url)
                print("endpoint.url == ", endpoint.url)
                urlRequest.httpMethod = endpoint.method

                // Set headers from the endpoint
                for (key, value) in endpoint.headers {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }

                // Set body if present
                if let body = endpoint.body {
                    urlRequest.httpBody = body
                }

                // Perform the request
                let (data, response) = try await URLSession.shared.data(for: urlRequest)

                // Check the response status code
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                print("\n\n\n")
                
                print(curlCommand(request: urlRequest))
                
                print("\n\n\n")

                
                if !(200...299).contains(httpResponse.statusCode) {
                    let decodedData = try JSONDecoder().decode(OAErrorResponse.self, from: data)
                    throw OANetworkError.errorResponse(decodedData)
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return decodedData
                } catch let DecodingError.dataCorrupted(context) {
                    print("Data corrupted: \(context)")
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found: \(context.debugDescription)")
                    print("Coding Path: \(context.codingPath)")
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found: \(context.debugDescription)")
                    print("Coding Path: \(context.codingPath)")
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type '\(type)' mismatch: \(context.debugDescription)")
                    print("Coding Path: \(context.codingPath)")
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }                

            } catch {
                // Increment attempt count
                attempts += 1
                
                // Log or handle the error for debugging purposes
                print("Attempt \(attempts) failed with error: \(error)")

                // Break out of the loop if retries are exhausted
                if attempts >= endpoint.retryCount {
                    throw error
                }

                // Wait before retrying (exponential backoff)
                let delay = pow(2.0, Double(attempts)) // 2, 4, 8 seconds, etc.
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        // Fallback in case of unexpected logic issue (this should never be reached)
        throw OANetworkError.unknown
    }
    
    func curlCommand(request: URLRequest) -> String {
        var command = "curl"

        // Add HTTP method
        if let method = request.httpMethod, method != "GET" {
            command += " -X \(method)"
        }

        // Add headers
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                command += " -H '\(key): \(value)'"
            }
        }

        // Add body data
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            command += " --data '\(bodyString)'"
        }

        // Add URL
        if let url = request.url?.absoluteString {
            command += " '\(url)'"
        }

        return command
    }
}


protocol OACoreServiceProtocol {
    func fetchPopular(pageNumber: Int) async throws -> PopularListModel?
}


// MARK: - Welcome
struct PopularListModel: Codable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let name, originalName: String?
    let mediaType: MediaType?
    let adult: Bool?
    let popularity: Double?
    let gender: Int?
    let knownForDepartment, profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case originalName = "original_name"
        case mediaType = "media_type"
        case adult, popularity, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}

enum MediaType: String, Codable {
    case person = "person"
}
