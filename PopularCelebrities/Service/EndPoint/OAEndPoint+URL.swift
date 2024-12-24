
import Foundation

extension OAEndpoint {
    
    var url: URL {
        var baseUrl = OAHost.base

        return URL(string: baseUrl.url + endPoint )!
    }

    var endPoint : String {
        return switch self {
        case .initializeToken: "/trending/person/day?language=en-US"
        }
    }
    var urlString: String {
        return url.absoluteString
    }
}
