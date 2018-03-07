//
//  String+Utility.swift
//  JPMCCode
//
//  Created by Rajdeep Arora on 06/03/18.
//  Copyright © 2018 Rajdeep Arora. All rights reserved.
//

import UIKit

public extension String {
    public func localize(_ comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? self)
    }
}

