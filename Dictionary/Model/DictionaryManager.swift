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
        case notFound(error: WordError)
    }

    private var words = [Word]()
    private var isSorted = false
    
    private init() {
        loadData()
    }

    func getAllOrdered() -> [Word] {
        if !isSorted {
            words = words.sorted(by: { $0.word < $1.word })
            isSorted = true
        }
        
        return words
    }

    func findWords(with prefix: String) -> [Word] {
        let filteredWords = words.filter({ $0.word.lowercased().hasPrefix(prefix.lowercased())})
        return filteredWords
    }

    private func loadData() {
        words = loadDictionary()
    }

    func loadDetailForWord(word: String) -> Promise<[WordDetail]> {
        let detailURL = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)")
        let request = URLRequest(url: detailURL!)
        
        return Promise<[WordDetail]> { resolve, reject, _ in
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    reject(error)
                } else if let data = data {
                    do {
                        let wordDetail = try JSONDecoder().decode([WordDetail].self, from: data)
                        resolve(wordDetail)
                    } catch {
                        do {
                            let wordError = try JSONDecoder().decode(WordError.self, from: data)
                            reject(Error.notFound(error: wordError))
                        } catch {
                            reject(Error.impossibleToDecode)
                        }
                    }
                } else {
                    reject(Error.impossibleToDecode)
                }
            }).resume()
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
