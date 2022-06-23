//
//  DefinitionViewController.swift
//  Dictionary
//
//  Created by matteo ugolini on 2020-09-16.
//  Copyright © 2020 EnovLab Inc. All rights reserved.
//

import UIKit
import PureLayout

private let verticalSpacing: CGFloat = 8
private let verticalSpacingBetweenDefinitions: CGFloat = 32

class DefinitionViewController: UIViewController {

    var word: Word? {
        didSet { reload() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func reload() {
        guard let term = word?.word else { return }

        title = term
        DictionaryManager.shared.loadDetailForWord(word: term).then { words in
            guard let word = words.first else {
                // display something
                return
            }

            self.display(wordDetail: word)
        }.catch { error in
            // error handling
            fatalError("Not implemented")
        }
    }

    private func display(wordDetail: WordDetail) {
        //TODO: complete the implementation
        fatalError("Not implemented")
    }

    private func buildTitleLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.text = text
        return label
    }

    private func buildMeaningLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.text = text
        return label
    }

    private func buildExampleLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        label.text = text
        return label
    }

    private func buildSynonymsLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.numberOfLines = 0
        label.text = text
        label.textColor = .darkGray
        return label
    }

    private func buildPhoneticLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = text
        return label
    }
}
