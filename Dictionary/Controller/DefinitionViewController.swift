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
        view.backgroundColor = UIColor.white
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
            self.display(error: error, defaultMeaning: self.word?.meaning)
        }
    }

    private func display(wordDetail: WordDetail) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(buildTitleLabel(text: wordDetail.word))
        if let phonetics = wordDetail.phonetics,
           let first = phonetics.filter({ $0.text != nil && !$0.text!.isEmpty}).first {
            stackView.addArrangedSubview(buildPhoneticLabel(text: first.text))
        }
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(UIView())
        for meaning in wordDetail.meanings ?? [] {
            stackView.addArrangedSubview(buildMeaningLabel(text: meaning.partOfSpeech))
            stackView.addArrangedSubview(UIView())
            for (index,definition) in (meaning.definitions ?? []).enumerated() {
                stackView.addArrangedSubview(view(for: definition, index: index+1))
                stackView.addArrangedSubview(UIView())
                stackView.addArrangedSubview(UIView())
            }
            stackView.addArrangedSubview(UIView())
        }
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func view(for definition: Definition, index: Int) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if let def = definition.definition {
            stackView.addArrangedSubview(buildMeaningLabel(text: "\(index). \(def)"))
        }
        
        if let example = definition.example {
            stackView.addArrangedSubview(buildExampleLabel(text: example))
        }
        
        if let synonyms = definition.synonyms,
           !synonyms.isEmpty {
            let text = synonyms.joined(separator: ", ")
            stackView.addArrangedSubview(buildSynonymsLabel(text: text))
        }
        
        return stackView
    }
    
    private func display(error: Error, defaultMeaning: String?) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        switch error {
        case DictionaryManager.Error.notFound(let wordError):
            stackView.addArrangedSubview(buildTitleLabel(text: wordError.title))
            stackView.addArrangedSubview(UIView())
            stackView.addArrangedSubview(buildMeaningLabel(text: wordError.message))
            stackView.addArrangedSubview(buildMeaningLabel(text: wordError.resolution))
            stackView.addArrangedSubview(UIView())
            
        default:
            stackView.addArrangedSubview(UIView())
            stackView.addArrangedSubview(buildExampleLabel(text: error.localizedDescription))
            stackView.addArrangedSubview(UIView())
        }
        
        if let defaultMeaning = defaultMeaning {
            stackView.addArrangedSubview(buildTitleLabel(text: "Here is what we found offline:"))
            stackView.addArrangedSubview(UIView())
            stackView.addArrangedSubview(buildMeaningLabel(text: defaultMeaning))
            stackView.addArrangedSubview(UIView())
        }
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
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
