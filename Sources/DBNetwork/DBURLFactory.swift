import Foundation


public typealias Path = String

public typealias Scheme = String

public typealias Host = String

public typealias Port = Int

public typealias QueryItem = [ String: String ]


public protocol DBURLFactoryProtocol {
    
    func makeURL(urlType: URLType) -> URL? 
}

public struct DBURLFactory: DBURLFactoryProtocol {
    
    public func makeURL(urlType: URLType) -> URL? {
        
        return urlType.url
    }
}


public enum URLType {
    
    case custom(
            Scheme,
            Host,
            Path,
            QueryItem? = nil,
            DBPagination? = nil,
            Port? = nil
         )
}

extension URLType {
    
    public var url: URL? {
        
        switch self {
            
        case .custom(
                let scheme,
                let host,
                let path,
                let query,
                let paging,
                let port):

            return DBURLBuilder()
            .set(host:   host)
            .set(scheme: scheme)
            .set(path:   path)
            .addQueryItems(items: query)
            .addPaginator(paginator: paging)
            .set(port:   port)
            .build()
            
        }
    }
}
