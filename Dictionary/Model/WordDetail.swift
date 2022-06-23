//
//  WordDetail.swift
//  Dictionary
//
//  Created by matteo ugolini on 2020-09-16.
//  Copyright © 2020 EnovLab Inc. All rights reserved.
//

import Foundation

struct Meaning: Decodable {
    let partOfSpeech: String?
    let definitions: [Definition]?
}

struct Phonetic: Decodable {
    let text: String?
    let audio: URL?
}

struct Definition: Decodable {
    let definition: String?
    let example: String?
    let synonyms: [String]?
}

struct WordDetail: Decodable {
    let word: String
    let meanings: [Meaning]?
    let phonetics: [Phonetic]?
    let definitions: [Definition]?
}
