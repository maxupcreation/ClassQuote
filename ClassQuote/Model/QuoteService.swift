import Foundation

class QuoteService {
    static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    static let pictureUrl = URL(string: "https://source.unsplash.com/random/1000x1000")!
    
    static func getQuote(callback: @escaping (Bool, Quote?) -> Void)  {
        let request = createQuoteRequest()
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return }
                
                
                callback(false, nil)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                
                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                    let text = responseJSON["quoteText"],
                    let author = responseJSON["quoteAuthor"] else {
                        callback(false, nil)
                        return
                }
                
                getImage { (data) in
                    guard let data = data else {
                        callback(false, nil)
                        return
                        
                    }
                    let quote = Quote(text: text, author: author, imageData: data)
                    callback(true, quote)
                }
            }
            
            
        }
        task.resume()
    }
    
    
    
    
    private static func createQuoteRequest() -> URLRequest {
        var request = URLRequest(url: quoteUrl)
        request.httpMethod = "POST"
        
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
    private static func getImage(completionHandler: @escaping ((Data?) -> Void)) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: QuoteService.pictureUrl) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completionHandler(data)
                }
            }
        }
        task.resume()
    }
    
}
