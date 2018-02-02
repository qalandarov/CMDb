//
//  URLEncoder.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/2/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//
//  Credits: Alamofire

import Foundation

extension URLRequest {
    mutating func encode(parameters: [String : Any]) {
        guard
            !parameters.isEmpty,
            let url = url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else {
                return
        }
        
        var percentEncodedQuery = urlComponents.percentEncodedQuery.map { $0 + "&" } ?? ""
        percentEncodedQuery += URLEncoder.query(parameters)
        urlComponents.percentEncodedQuery = percentEncodedQuery
        self.url = urlComponents.url
    }
    
    var contentType: String? {
        get {
            return allHTTPHeaderFields?[ContentType.HeaderField]
        }
        set {
            setValue(newValue, forHTTPHeaderField: ContentType.HeaderField)
        }
    }
}

private struct URLEncoder {
    
    /**
     Creates percent-escaped, URL encoded query string from the given parameters dictionary.
     
     - parameter parameters: The parameters dictionary.
     
     - returns: The percent-escaped, URL encoded query string.
     */
    static func query(_ parameters: [String: Any]) -> String {
        return parameters.map { escape($0) + "=" + escape("\($1)") }.joined(separator: "&")
    }
    
    /**
     Returns a percent-escaped string following RFC 3986 for a query string key or value.
     
     RFC 3986 states that the following characters are "reserved" characters.
     
     - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
     - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
     
     In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.
     
     - parameter string: The string to be percent-escaped.
     
     - returns: The percent-escaped string.
     */
    static private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        
        let escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        
        return escaped
    }
}
