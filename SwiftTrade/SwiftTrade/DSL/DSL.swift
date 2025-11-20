//
//  DSL.swift
//  SwiftTrade
//
//  Created by Petr Homola on 03/11/2025.
//

import Foundation

enum Token {
    case identifier(String)
    case number(Int)
    case string(String)
    case symbol(String)
}

func scannerExper() {
    let scanner = Scanner(string: """
        abcd
        1234
        "ABCD"
        efgh ijkl
        """)
    scanner.charactersToBeSkipped = .whitespacesAndNewlines
    var tokens: [Token] = []
    while !scanner.isAtEnd {
        if let text = scanner.scanCharacters(from: .decimalDigits) {
            tokens.append(.number(Int(text)!))
            continue
        }
        if let text = scanner.scanCharacters(from: .alphanumerics) {
            tokens.append(.identifier(text))
            continue
        }
        let char = scanner.string[scanner.currentIndex]
        scanner.currentIndex = scanner.string.index(scanner.currentIndex, offsetBy: 1)
        if char == "\"" {
            if let text = scanner.scanUpToString("\"") {
                tokens.append(.string(text))
                scanner.currentIndex = scanner.string.index(scanner.currentIndex, offsetBy: 1)
                continue
            }
        }
        if scanner.charactersToBeSkipped!.contains(char.unicodeScalars.first!) {
            continue
        }
        tokens.append(.symbol(String(char)))
//        if let text = scanner.scanUpToCharacters(from: .newlines) {
//            print("line: <\(text)>")
//        }
    }
    for token in tokens {
        print(token)
    }
}
