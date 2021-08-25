import Foundation
import Combine

public protocol APIRequestBaseType {
    
    associatedtype T: Codable
    
    func getData(for request: URLRequest,
                 decoder: JSONDecoder
    ) -> AnyPublisher<T, Error>
}

public struct AnyAPIRequest<T: Codable>: APIRequestBaseType {
    
    var network: Networkprotocol
    
    public init(_ network: Networkprotocol = Network()) {

        self.network = network
    }
    
    public func getData(for request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        
        return network.run(for: request)
            .tryMap{try network.validate($0.data, $0.response)}
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
