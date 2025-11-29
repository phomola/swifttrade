import Foundation

let active_days_per_year = 252.0

func calculate_total_return(final_portfolio_value: Float64, initial_capital: Float64) -> Float64 {
    return (final_portfolio_value / initial_capital) - 1
}

func calculate_annualised_return(total_return: Float64, num_days: Int) -> Float64 {
    return pow(1 + total_return, active_days_per_year / Float64(num_days)) - 1
}

func calculate_annualised_volatility(daily_returns: Series) -> Float64 {
    return daily_returns.std() * sqrt(active_days_per_year)
}

func calculate_sharpe_ratio(annualised_return: Float64, annualised_volatility: Float64, risk_free_rate: Float64 = 0 ) -> Float64 {
    return (annualised_return - risk_free_rate) / annualised_volatility
}

func calculate_sortino_ratio(daily_returns: Series, annualised_return: Float64, risk_free_rate: Float64 = 0) -> Float64 {
    let negative_returns = daily_returns.filter { $0 < 0 }
    let downside_volatility = negative_returns.std() * sqrt(active_days_per_year)
    return (annualised_return - risk_free_rate) / downside_volatility
}

func calculate_maximum_drawdown(portfolio_values: Series) -> Float64 {
    let drawdown = portfolio_values.div(portfolio_values.cummax()).minus(1)
    return drawdown.min()
}
