//
//  ErrorHandler.swift
//  JPMCCode
//
//  Created by Rajdeep Arora on 3/6/18.
//  Copyright © 2018 Rajdeep Arora. All rights reserved.

import UIKit

// Takes an error and returns final (title, message) tuple to display

func messageFromError(_ error: NSError) -> (String, String) {
    let tuple = titleAndMessageForErrorCode(error.code)
    var description = tuple.1
    
    // Append if error description has system messages
    if error.userInfo["hasSystemMessages"] as? Bool == true {
        description += "\n\(error.localizedDescription)"
    }
    
    return (tuple.0, description)
}

// Takes an error code and returns default (title, message) tuple to display
fileprivate func titleAndMessageForErrorCode(_ errorCode: Int) -> (String, String) {
    
    var title: String = ""
    var message: String = ""
    
    switch errorCode {
    // Posix/socket level errors
    case 0:
        title = "Server Error".localize()
        message = "Unable to fetch details, Please Try again".localize()
        
    // HTTP response errors
    case 400:
        title = "Bad Request".localize()
        message = "A malformed request was received by the server".localize()
    case 401:
        title = "Invalid access token".localize()
        message = "Your session has expired. Please login again".localize()
    case 403:
        title = "Unauthorized".localize()
        message = "Your login has expired, please login again".localize()
    case 404:
        title = "Not Found".localize()
        message = "Requested entity/entities was/were not found".localize()
    case 405:
        title = "Not Allowed".localize()
        message = "The request is not allowed for the requested resource".localize()
    case 406:
        title = "Not Acceptable".localize()
        message = "The request is not acceptable according to the Accept, or Accept-Language header, in the request".localize()
    case 409:
        title = "Conflict".localize()
        message = "The request could not be completed due to a conflict".localize()
    case 415:
        title = "Network Error".localize()
        message = "Unsupported message type".localize()
    case 500:
        title = "Server Error".localize()
        message = "Unable to fetch details, Please Try again".localize()
    case 503:
        title = "Server Error".localize()
        message = "Unable to fetch details, Please Try again".localize()
    case 8001:
        title = "Network Error".localize()
        message = "Please turn on the internet".localize()
    case 1560:
        title = "Error".localize()
        message = "Core data saving error".localize()
    case -1009:
        title = "Network Error".localize()
        message = "Please turn on the internet".localize()
    case 9191:
        title = "Response Error".localize()
        message = "Unable to fetch details, Please Try again.".localize()
    case -1004:
        title = "Error".localize()
        message = "Unable to fetch details, Please Try again".localize()
    case -1001:
        title = "Error".localize()
        message = "The request timed out".localize()
        
    // Service/business logic errors
    default:
        title = "Error".localize()
        message = "Unable to fetch details, Please Try again".localize() //+ " \(errorCode)"
    }
    
    return (title, message)
}

