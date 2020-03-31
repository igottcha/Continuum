//
//  PostError.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

enum PostError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordFound
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Hype, That's not very Hype..."
        case .unexpectedRecordFound:
            return "Unexpected record found when none should have been returned"
        }
    }
    
}
