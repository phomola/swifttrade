// The parser for a domain-specific language (DSL) for trading/backtesting.
// It operates on trees of statements/expressions.
// The DSL is optimised for LLMs and RAG in order to be well-suited for large databases of trading strategies/indicators
// (RAG can be tested with vector extensions for PostgreSQL or SQLite).
// Code written in the DSL can also be translated into WASM and run in a browser within our backtesting engine.

// How DSL code is interpreted/transpiled:
// - all functions and methods are asynchronous and throwing,
// - all objects are actors to avoid race conditions,
// - as a consequence, all built-in functions need be asynchronous and throwing,
// - built-in objects needn't be actors but exposed interfaces need be safe.

import Foundation

enum ParseError: Error, CustomStringConvertible {
    case noTokens
    case notImplemented
    case syntaxError(message: String, position: Position)

    var description: String {
        switch self {
        case .noTokens:
            return "no tokens provided"
        case .notImplemented:
            return "not implemented"
        case .syntaxError(message: let message, position: let position):
            return "\(message) (at \(position))"
        }
    }
}

func parse(code: String) throws -> [StatementNode] {
    let tokens = Tokens(tokens: tokenize(string: code))
    let statements = try parse_top_level(tokens: tokens)
    let token = try tokens.first(checkForEof: false)
    if case .eof(position: _) = token {
        return statements
    }
    throw ParseError.syntaxError(message: "expected EOF", position: token.position)
}

final class Tokens: CustomStringConvertible {
    let tokens: [Token]
    var index: Int

    init(tokens: [Token]) {
        self.tokens = tokens
        self.index = 0
    }

    func first(checkForEof: Bool = true) throws -> Token {
        if index >= tokens.count { throw ParseError.noTokens }
        let token = tokens[index]
        if checkForEof {
            if case let .eof(position: position) = token { throw ParseError.syntaxError(message: "unexpected EOF", position: position) }
        }
        return token
    }

    func advance() {
        index += 1
    }

    var description: String {
        var values = [String]()
        for token in tokens[index..<tokens.count] {
            values.append(token.value)
        }
        return values.description
    }
}

func parse_top_level(tokens: Tokens) throws -> [StatementNode] {
    var statements: [StatementNode] = []
    while true {
        let token = try tokens.first(checkForEof: false)
        if case .eof = token {
            return statements
        }
        if case let .identifier(value: value, position: position) = token {
            if value == "var" {
                tokens.advance()
                let token = try tokens.first()
                if case let .identifier(value: variable, position: position) = token {
                    tokens.advance()
                    let token = try tokens.first()
                    if case let .symbol(value: value, position: _) = token {
                        if value == "=" {
                            tokens.advance()
                            let expression = try parse_expression(tokens: tokens)
                            statements.append(VarAssignmentNode(variable: variable, expression: expression))
                            continue
                        }
                    }
                    throw ParseError.syntaxError(message: "expected '='", position: position)        
                }
                throw ParseError.syntaxError(message: "expected identifier", position: position)        
            }
        }
        throw ParseError.syntaxError(message: "expected 'var'", position: token.position)
    }
}

func parse_expression(tokens: Tokens) throws -> ExpressionNode {
    let token = try tokens.first()
    if case let .number(value: value1, position: _) = token {
        tokens.advance()
        let token = try tokens.first(checkForEof: false)
        if case let .symbol(value: value, position: _) = token {
            if value == "." {
                tokens.advance()
                let token = try tokens.first()
                if case let .number(value: value2, position: _) = token {
                    tokens.advance()
                    return FloatNode(value: Double("\(value1).\(value2)")!)
                } else {
                    throw ParseError.syntaxError(message: "expected number", position: token.position)
                }
            }
        }
        return IntegerNode(value: value1)
    }
    if case let .string(value: value, position: _) = token {
        tokens.advance()
        return StringNode(value: value)
    }
    throw ParseError.syntaxError(message: "expected expression", position: token.position)
}
