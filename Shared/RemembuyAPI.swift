import Foundation
import Combine

enum RemembuyAPI {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://remembuy.kodare.com/api/")!
}

enum APIPath: String {
    case items = "items/"
    case add = "add/"
}

extension RemembuyAPI {
    
    static func get(_ path: APIPath) -> AnyPublisher<[Item], Error> {
        guard var components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [
            URLQueryItem(name: "username", value: "boxed"), // TODO: preferences
            URLQueryItem(name: "password", value: "q"), // TODO: preferences
        ]
        
        let request = URLRequest(url: components.url!)
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func post(_ path: APIPath, parameters: Dictionary<String, String>) -> AnyPublisher<Item, Error> {
        var params = parameters
        params["username"] = "boxed" // TODO: preferences
        params["password"] = "q" // TODO: preferences
        
        guard var components = URLComponents(url: URL(string: "http://example.com")!, resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        
        components.queryItems = params.map { k, v in URLQueryItem(name: k, value: v) }
        
        var request = URLRequest(url: baseUrl.appendingPathComponent(path.rawValue))
        request.httpBody = Data(components.query!.utf8)
        request.httpMethod = "POST"
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
