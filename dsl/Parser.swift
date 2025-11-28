// The parser for a domain-specific language (DSL) for trading/backtesting.
// It operates on trees of statements/expressions.
// The DSL is optimised for LLMs and RAG in order to be well-suited for large databases of trading strategies/indicators
// (RAG can be tested with vector extensions for PostgreSQL or SQLite).
// Code written in the DSL can also be translated into WASM and run in a browser within our backtesting engine.

import Foundation

enum ParseError {
    case syntaxError(message: String, position: Position)
}
