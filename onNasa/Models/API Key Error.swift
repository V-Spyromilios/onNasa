//
//  API Key Error.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 24.05.23.
//

import Foundation

enum APIKeyError: String, Error {
	case unknownKey = "API Key Not Found. Check 'Configuration'"
}
