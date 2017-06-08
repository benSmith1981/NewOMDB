/*
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ErrorResponse {
	public var response : Bool?
	public var error : String?

    public var standardNSError: NSError?
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let ErrorResponse_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ErrorResponse]
    {
        var models:[ErrorResponse] = []
        for item in array
        {
            models.append(ErrorResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

        if let responsString = dictionary["Response"] as? String {
            response = (responsString == "False") ? false : true
        }
		error = dictionary["Error"] as? String
        standardNSError = self.createNSErrorFromOMDBErrorResponse()
	}
    
    convenience public init?(nsError: NSError) {
        self.init(dictionary: ["Error" : "Other", "Response" : false])
        standardNSError = createNSError(error: nsError)
    }

    public func createNSError(error: NSError) -> NSError{
        if error.isNetworkConnectionError() || error.isHttpError() {
            let userInfo = [
                NSLocalizedDescriptionKey: "Network Issue",
                NSLocalizedFailureReasonErrorKey: "Network Issue",
                NSLocalizedRecoverySuggestionErrorKey: "Connect to network"
            ]
            return NSError.init(domain: "Network Connection", code: -57, userInfo: userInfo)
        } else if error.isJSONParsingError(){
            let userInfo = [
                NSLocalizedDescriptionKey: "The JSON is faulty! Some backend developer needs to be fired",
                NSLocalizedFailureReasonErrorKey: "The JSON is faulty!!",
                NSLocalizedRecoverySuggestionErrorKey: "Fire the backend developer"
            ]
            return NSError.init(domain: "Bad JSON", code: -57, userInfo: userInfo)
        } else {
            return error
        }
    }
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.response, forKey: "Response")
		dictionary.setValue(self.error, forKey: "Error")

		return dictionary
	}
    
    public func createNSErrorFromOMDBErrorResponse() -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: error,
            NSLocalizedFailureReasonErrorKey: error,
            NSLocalizedRecoverySuggestionErrorKey: "Try typing a better name"
        ]
        return NSError.init(domain: "OMDB Domain", code: -57, userInfo: userInfo)
    }

}