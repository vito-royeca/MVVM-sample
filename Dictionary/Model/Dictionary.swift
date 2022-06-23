//
//  Dictionary.swift
//  Dictionary
//
//  Created by matteo ugolini on 2020-09-16.
//  Copyright © 2020 EnovLab Inc. All rights reserved.
//

import Foundation

struct Word: Decodable {
    let word: String
    let meaning: String
}

struct Dictionary: Decodable {
    let words: [Word]
}
