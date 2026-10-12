import Foundation

final class EvalContext {
    var variables: [String: Value]
    let parent: EvalContext?

    init(parent: EvalContext? = nil) {
        self.variables = [:]
        self.parent = parent
    }
}

protocol Statement: CustomStringConvertible {
    func run(context: EvalContext) async throws
}

final class VarAssignment: Statement {
    let variable: String
    let expression: Expression

    init(variable: String, expression: Expression) {
        self.variable = variable
        self.expression = expression
    }

    var description: String { return "var \(variable) = \(expression)" }

    func run(context: EvalContext) async throws {
        context.variables[variable] = try await expression.evaluate(context: context)
    }
}

protocol Expression: CustomStringConvertible {
    func evaluate(context: EvalContext) async throws -> Value
}

final class IntegerExpression: Expression {
    let value: Int

    init(value: Int) {
        self.value = value
    }

    var description: String { return "\(value)" }

    func evaluate(context: EvalContext) async throws -> Value {
        return IntegerValue(value: value)
    }
}

final class FloatExpression: Expression {
    let value: Double

    init(value: Double) {
        self.value = value
    }

    var description: String { return "\(value)" }

    func evaluate(context: EvalContext) async throws -> Value {
        return FloatValue(value: value)
    }
}

final class StringExpression: Expression {
    let value: String

    init(value: String) {
        self.value = value
    }

    var description: String { return "\(value)" }

    func evaluate(context: EvalContext) async throws -> Value {
        return StringValue(value: value)
    }
}
