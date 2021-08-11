import Foundation
import Combine

public protocol APIRequestBaseType {
    
    associatedtype T: Codable
    
    func getData(for request: URLRequest
    ) -> AnyPublisher<T, Error>
}

extension APIRequestBaseType {
    
    func getData(for request: URLRequest
    ) -> AnyPublisher<T, Error> {
        
        return getData(for: request)
    }
}

public struct AnyAPIRequest<T: Codable>: APIRequestBaseType {
    
    var network: Networkprotocol
    
    var decoder: JSONDecoder
    
    public init(_ network: Networkprotocol = Network(),
         _ decoder: JSONDecoder = JSONDecoder()) {

        self.network = network
        
        self.decoder = decoder
    }
    
    public func getData(for request: URLRequest) -> AnyPublisher<T, Error> {
        
        return network.run(for: request)
            .tryMap{try network.validate($0.data, $0.response)}
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
