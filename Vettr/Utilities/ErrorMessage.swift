//
//  ErrorMessage.swift
//  Vettr
//
//  Created by Steven Schwab on 12/11/22.
//

import Foundation

enum VRError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
