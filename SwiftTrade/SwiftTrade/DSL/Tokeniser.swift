//
//  DSL.swift
//  SwiftTrade
//
//  Created by Petr Homola on 03/11/2025.
//

import Foundation

func scannerExper() {
    for token in tokenizer(string: """
        abcd
        1234
        "ABCD"
        efgh ijkl
        """) {
        print(token)
    }
}

struct Position {
    let index: String.Index
}

enum Token {
    case identifier(value: String, position: Position)
    case number(value: Int, position: Position)
    case string(value: String, position: Position)
    case symbol(value: String, position: Position)
}

func tokenizer(string: String) -> [Token] {
    let scanner = Scanner(string: string)
    scanner.charactersToBeSkipped = .whitespacesAndNewlines
    var tokens: [Token] = []
    while !scanner.isAtEnd {
        let index = scanner.currentIndex
        if let text = scanner.scanCharacters(from: .decimalDigits) {
            tokens.append(.number(value: Int(text)!, position: Position(index: index)))
            continue
        }
        if let text = scanner.scanCharacters(from: .alphanumerics) {
            tokens.append(.identifier(value: text, position: Position(index: index)))
            continue
        }
        let char = scanner.string[scanner.currentIndex]
        scanner.currentIndex = scanner.string.index(scanner.currentIndex, offsetBy: 1)
        if char == "\"" {
            if let text = scanner.scanUpToString("\"") {
                tokens.append(.string(value: text, position: Position(index: index)))
                scanner.currentIndex = scanner.string.index(scanner.currentIndex, offsetBy: 1)
                continue
            }
        }
        if scanner.charactersToBeSkipped!.contains(char.unicodeScalars.first!) {
            continue
        }
        tokens.append(.symbol(value: String(char), position: Position(index: index)))
//        if let text = scanner.scanUpToCharacters(from: .newlines) {
//            print("line: <\(text)>")
//        }
    }
    return tokens
}
