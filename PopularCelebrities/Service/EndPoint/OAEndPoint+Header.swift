
import Foundation
extension OAEndpoint {
    var headers: [String: String] {
        return switch self {
        default :
            commonHeaders
        }
    }

    private var commonHeaders: [String : String]  {
        var request : [String: String] = [:]
        request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZWQwYjQxMTUyNDFlNmRmZTc5ZDU3MGMwYzQ4N2E4MiIsIm5iZiI6MTczNTAyNTQzNS4xNDQsInN1YiI6IjY3NmE2MzFiZmNjZTM5ZDllZTY0YTkzNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.xNo-S6lGKyhICPTtlPSphJuHjDKUJCMl6-PjcWL3eM8"
         request["accept"] = "application/json"
        return request
    }
}
