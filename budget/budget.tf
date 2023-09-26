
resource "aws_budgets_budget" "this" {
  name              = "monthly-budget"
  budget_type       = "COST"
  limit_amount      = "300.00"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2023-05-01_00:01"
}
