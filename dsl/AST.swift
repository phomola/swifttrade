import Foundation

final class TranslationContext {
    let parent: TranslationContext?

    init(parent: TranslationContext? = nil) {
        self.parent = parent
    }
}

protocol StatementNode: CustomStringConvertible {
    func statement(context: TranslationContext) -> Statement
}

final class VarAssignmentNode: StatementNode {
    let variable: String
    let expression: ExpressionNode

    init(variable: String, expression: ExpressionNode) {
        self.variable = variable
        self.expression = expression
    }

    var description: String { return "var \(variable) = \(expression)" }

    func statement(context: TranslationContext) -> Statement {
        return VarAssignment(variable: variable, expression: expression.expression(context: context))
    }
}

protocol ExpressionNode: CustomStringConvertible {
    func expression(context: TranslationContext) -> Expression
}

final class IntegerNode: ExpressionNode {
    let value: Int

    init(value: Int) {
        self.value = value
    }

    var description: String { return "\(value)" }

    func expression(context: TranslationContext) -> Expression {
        return IntegerExpression(value: value)
    }
}

final class FloatNode: ExpressionNode {
    let value: Double

    init(value: Double) {
        self.value = value
    }

    var description: String { return "\(value)" }

    func expression(context: TranslationContext) -> Expression {
        return FloatExpression(value: value)
    }
}

final class StringNode: ExpressionNode {
    let value: String

    init(value: String) {
        self.value = value
    }

    var description: String { return "\(value)" }

    func expression(context: TranslationContext) -> Expression {
        return StringExpression(value: value)
    }
}
