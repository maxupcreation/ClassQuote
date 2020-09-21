import Foundation

enum NetWorkError : Error {
    case noData
    case noResponse
    case undecodable
    case noImage
}

class QuoteService {
    
    
   // static var shared = QuoteService()
    // private init(){}
    
    init(session : URLSession = URLSession(configuration: .default) , imageSession : URLSession = URLSession(configuration: .default)){
        self.session = session
        self.imageSession = imageSession
    }
    
 
    
   private let session : URLSession
  private let  imageSession : URLSession
    
    func getQuote(callback: @escaping (Result<Quote, NetWorkError>) -> Void)  {
        guard let request = createQuoteRequest() else { return }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                callback(.failure(.noData))
                return }
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(.failure(.noResponse))
                return
            }
            
            
            guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                let text = responseJSON["quoteText"],
                let author = responseJSON["quoteAuthor"] else {
                    callback(.failure(.undecodable))
                    return
            }
            
            self.getImage { (data) in
                guard let data = data else {
                    callback(.failure(.noImage))
                    return
                    
                }
                let quote = Quote(text: text, author: author, imageData: data)
                callback(.success(quote))
            }
            
            
            
        }
        task.resume()
    }
    
    private func createQuoteRequest() -> URLRequest? {
 
        guard let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/") else {
            return nil
        }
        var request = URLRequest(url: quoteUrl)
        request.httpMethod = "POST"
        
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
    private func getImage(completionHandler: @escaping ((Data?) -> Void)) {

        guard let pictureUrl = URL(string: "https://source.unsplash.com/random/1000x1000") else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with:pictureUrl) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completionHandler(data)
                }
            }
        }
        task.resume()
    }
    
}
