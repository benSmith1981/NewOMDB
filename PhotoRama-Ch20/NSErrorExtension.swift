//
//  NSErrorExtension.swift
//  NewOMBD
//
//  Created by Ben Smith on 08/06/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

extension NSError {
    func isNetworkConnectionError() -> Bool {
        let networkErrors = [NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet, NSURLErrorBadServerResponse]

        if self.domain == NSURLErrorDomain || networkErrors.contains(self.code) {
            return true
        }
        return false
    }
    
    func isHttpError() -> Bool {
        if self.code <= 311 && self.code >= 300 {
            return true
        }
        return false
    }
    
    func isJSONParsingError() -> Bool {
        if self.domain == NSCocoaErrorDomain {
            return true
        }
        return false
    }
}
