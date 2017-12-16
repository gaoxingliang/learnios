//
//  Base64.swift
//  SwiftWeather
//
//  Created by edward.gao on 16/12/2017.
//  Copyright © 2017 Jake Lin. All rights reserved.
//

import Foundation

struct Base64 {
    /// swift Base64处理
    /**
     *   编码
     */
    static func base64Encoding(plainString:String)->String
    {
        
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    /**
     *   解码
     */
    static func base64Decoding(encodedString:String)->String
    {
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    
    static func base64Decoding(rawData: Data) -> String {
        let decodedString = NSString(data: rawData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    
}
