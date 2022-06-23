//
//  WordError.swift
//  Dictionary
//
//  Created by Vito Royeca on 6/23/22.
//  Copyright © 2022 EnovLab Inc. All rights reserved.
//

import Foundation

struct WordError: Decodable {
    let title: String
    let message: String
    let resolution: String
}
