//
//  HTTPBin.swift
//
//  Copyright (c) 2014-2018 Alamofire Software Foundation (http://alamofire.org/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Alamofire
import Foundation

extension String {
    static let httpBinURLString = "https://httpbin.org"
}

extension URL {
    static func makeHTTPBinURL(path: String = "get") -> URL {
        let url = URL(string: .httpBinURLString)!
        return url.appendingPathComponent(path)
    }
}

extension URLRequest {
    static func makeHTTPBinRequest(path: String = "get",
                                   method: HTTPMethod = .get,
                                   headers: HTTPHeaders = .init(),
                                   timeout: TimeInterval = 60,
                                   cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> URLRequest {
        var request = URLRequest(url: .makeHTTPBinURL(path: path))
        request.httpMethod = method.rawValue
        request.headers = headers
        request.timeoutInterval = timeout
        request.cachePolicy = cachePolicy

        return request
    }

    static func make(url: URL = URL(string: "https://httpbin.org/get")!, method: HTTPMethod = .get, headers: HTTPHeaders = .init()) -> URLRequest {
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers

        return request
    }
}

extension Data {
    var asString: String {
        return String(data: self, encoding: .utf8)!
    }
}

struct HTTPBinRequest: URLRequestConvertible {
    let method: HTTPMethod
    let parameters: HTTPBinParameters
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest.makeHTTPBinRequest(path: method.rawValue.lowercased(),
                                                    method: method,
                                                    headers: [])
        request = try JSONParameterEncoder().encode(parameters, into: request)

        return request
    }
}

struct HTTPBinResponse: Decodable {
    let headers: [String: String]
    let origin: String
    let url: String
    let data: String?
    let form: [String: String]?
    let args: [String: String]
}

struct HTTPBinParameters: Encodable {
    static let `default` = HTTPBinParameters(property: "property")

    let property: String
}
