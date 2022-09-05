//
//  CFinder.swift
//  clashFound
//
//  Created by Mike Vinci on 9/4/22.
//
import SwiftSoup
import Foundation

var htmlS = ""
//let urlString = ""

func parseHTML(urlString: String) -> String {
    if let url = URL(string: urlString) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) {data,response,error in
            if let data = data {
                htmlS = String(data: data, encoding: .ascii)!
//                print(htmlS)
            }
        }.resume()
    } else {
        print("Error: \(urlString) doesn't URL")
    }
    return htmlS
}
