//
//  DictionaryManager.swift
//  Dictionary
//
//  Created by matteo ugolini on 2020-09-16.
//  Copyright © 2020 EnovLab Inc. All rights reserved.
//

import Foundation
import Hydra

class DictionaryManager {
    static let shared = DictionaryManager()

    indirect enum Error: Swift.Error {
        case impossibleToDecode
    }

    private init() {
        loadData()
    }

    func getAllOrdered() -> [Word] {
        //TODO: Implement the method
        fatalError("Not implemented")
    }

    func findWords(with prefix: String) -> [Word] {
        //TODO: Implement the method
        fatalError("Not implemented")
    }

    private func loadData() {
        //TODO: Implement the method
        fatalError("Not implemented")
    }

    func loadDetailForWord(word: String) -> Promise<[WordDetail]> {
        let detailURL = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)")

        return Promise<[WordDetail]> { resolve, reject, _ in
            //TODO: Fetch the data from the detailURL and parse into [WordDetail]
            fatalError("Not implemented")
        }
    }

    private func loadDictionary() -> [Word] {
        guard let path = Bundle.main.path(forResource: "dictionary", ofType: "json") else {
            fatalError("Cannot locate dictionary")
        }

        let data = try! NSData(contentsOfFile: path) as Data
        return try! JSONDecoder().decode(Dictionary.self, from: data).words
    }
}
