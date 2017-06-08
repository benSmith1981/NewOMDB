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

        if self.domain == NSURLErrorDomain || self.domain == NSCocoaErrorDomain || networkErrors.contains(self.code) {
            return true
        }
        return false
    }
}
