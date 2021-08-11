import Foundation


public class DBURLBuilder {
    
    private var components: URLComponents

    public init() {
        
       self.components = URLComponents()
    }

    @discardableResult
    public func set(scheme: String) -> Self {
        
       self.components.scheme = scheme
        
       return self
    }

    @discardableResult
    public func set(host: String) -> Self {
        
        self.components.host = host
        
        return self
    }

    @discardableResult
    public func set(port: Int?) -> Self {
        
        if let port = port {
            
            self.components.port = port
        }
       
        
        return self
    }

    @discardableResult
    public func set(path: String) -> Self {
        
        var path = path
        
        if !path.hasPrefix("/") {
        
            path = "/" + path
        }
        
        self.components.path = path
        
        return self
    }

    @discardableResult
    public func addQueryItem(name: String, value: String) -> Self  {
        
        if self.components.queryItems == nil {
            
            self.components.queryItems = []
        }
        
        self.components.queryItems?.append(URLQueryItem(name: name, value: value))
        
        return self
    }
    
    @discardableResult
    public func addQueryItems(items: QueryItem?) -> Self {
        
        if let unwrappedItems = items, !unwrappedItems.isEmpty {
            
            unwrappedItems.forEach {

                addQueryItem(name: $0.key, value: $0.value)
            }
        }
        return self
    }
    
    @discardableResult
    public func addPaginator(paginator: DBPagination?) -> Self  {

        if let unwrappedPaginator = paginator {
            
            if self.components.queryItems == nil {
                
                self.components.queryItems = []
            }
            
            // Per page
            self.components.queryItems?.append(
                URLQueryItem(
                    name: unwrappedPaginator.pageKey,
                    value: String(describing: unwrappedPaginator.pageValue)
                )
            )
            // number of item per page
            self.components.queryItems?.append(
                URLQueryItem(
                    name: unwrappedPaginator.itemKey,
                    value: String(describing: unwrappedPaginator.itemValue)
                )
            )
        }
        
        return self
    }

    public func build() -> URL? {
        
        return self.components.url
    }
}
