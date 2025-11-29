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

enum ParseError: CustomStringConvertible {
    case syntaxError(message: String, position: Position)

    var description: String {
        switch self {
        case .syntaxError(message: let message, position: let position):
            return "\(message) (\(position))"
        }
    }
}
