-- Create a reader database user
-- do not have priviledge to create user
create login reader with password = 'abc12345'

create user reader for login reader

grant select on current_accounts to reader

grant select on current_cash_flows to reader

grant select on debt_to_income_ratios to reader

grant select on user_bank to reader

grant select on user_debt to reader

grant select on user_incomes to reader

grant select on user_investment to reader