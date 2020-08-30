-- Views

/* 
	View that returns a table of all accounts based on their latest update date.
	Returrns all of the updated information.
*/
if object_id ('dbo.current_accounts')is not null
	drop view dbo.current_accounts
go

create view current_accounts as
	select
		*
	from
		(
		/* return a table of the accounts ordered by their creation_date
		and a row_number field of each cash flow in order to pick the latest one
		*/
		SELECT 
			*,
			ROW_NUMBER() over (partition by account_id order by account_update_date desc) as RowNum 
		from
			account_updates) as x 
	WHERE RowNum = 1
go

-- select the view
select * from current_accounts
go


/* 
	View that returns a table of all user cash flows based on their latest update date.
	Returrns all of the updated information.
*/

if object_id ('dbo.current_cash_flows')is not null
	drop view dbo.current_cash_flows
go

create view current_cash_flows as 
	select
		*
	from
		(
		/* return a table of the cash_flows ordered by their creation_date
		and a row_number field of each cash flow in order to pick the latest one
		*/
		select
			*,
			row_number() over (partition by cash_flow_id order by cash_flow_update_date desc) as RowNum 
		from cash_flow_updates) as x 
	where RowNum = 1
go

select * from current_cash_flows
go


/*
	Return a table of total debt balances by user, using the
	current debt accounts
*/

if object_id('dbo.user_debt') is not null
	drop view dbo.user_debt
go

create view user_debt as
	select
		users.users_id,
		sum(latest_accounts.balance) as current_total_debt
	from 
		accounts acct
		join
		users on acct.users_id = users.users_id
			join
		(
			select
				account_id, 
				balance,
				account_update_date
			from
				dbo.current_accounts
		) as latest_accounts on latest_accounts.account_id = acct.account_id
			join
		account_type actype on acct.account_type_id = actype.account_type_id		
			join
		account_category act_cat on actype.account_category_id = act_cat.account_category_id
	where
		act_cat.account_category_name = 'Debt'
	group by users.users_id
go

select * from user_debt order by current_total_debt desc
go



/*
	Return a table of total bank balances by user, using the
	current bank accounts
*/

if object_id('dbo.user_bank') is not null
	drop view dbo.user_bank
go

create view user_bank as
	select
		users.users_id,
		sum(latest_accounts.balance) as current_total_bank_balances
	from 
		accounts acct
		join
		users on acct.users_id = users.users_id
			join
		(
			select
				account_id, 
				balance,
				account_update_date
			from
				dbo.current_accounts
		) as latest_accounts on latest_accounts.account_id = acct.account_id
			join
		account_type actype on acct.account_type_id = actype.account_type_id		
			join
		account_category act_cat on actype.account_category_id = act_cat.account_category_id
	where
		act_cat.account_category_name = 'Bank'
	group by users.users_id
go


select * from dbo.user_bank


/*
	Return a table of total investment balances by user, using the
	current investment accounts
*/

if object_id('dbo.user_investment') is not null
	drop view dbo.user_investment
go

create view user_investment as
	select
		users.users_id,
		sum(latest_accounts.balance) as current_total_investment_balances
	from 
		accounts acct
			join
		users on acct.users_id = users.users_id
			join
		(
			select
				account_id, 
				balance,
				account_update_date
			from
				dbo.current_accounts
		) as latest_accounts on latest_accounts.account_id = acct.account_id
			join
		account_type actype on acct.account_type_id = actype.account_type_id		
			join
		account_category act_cat on actype.account_category_id = act_cat.account_category_id
	where
		act_cat.account_category_name = 'Investment'
	group by users.users_id
go


select * from dbo.user_investment

select
	users.users_id
from 
	accounts acct
		right join
	users on acct.users_id = users.users_id











select
	bank.users_id,
	bank.current_total_bank_balances,
	debt.current_total_debt,
	inv.current_total_investment_balances
from
	dbo.user_bank bank
		join
	dbo.user_debt debt on bank.users_id = debt.users_id
		join
	dbo.user_investment inv on bank.users_id = inv.users_id



select
	bank.users_id,
	bank.current_total_bank_balances,
	debt.current_total_debt,
	inv.current_total_investment_balances
from
	dbo.user_bank bank
		full outer join
	dbo.user_debt debt on bank.users_id = debt.users_id
		full outer join
	dbo.user_investment inv on bank.users_id = inv.users_id



-- user incomes
if object_id('dbo.user_incomes') is not null
	drop view dbo.user_incomes
go

create view user_incomes as 
	select
		u.users_id,
		cf.cash_flow_id,
		latest_income.discretionary_monthly_income
	from
		cash_flow cf
			join
		users u on cf.users_id = u.users_id
			join
		(
			select
				cash_flow_id, 
				discretionary_monthly_income
			from
				dbo.current_cash_flows
		) as latest_income on cf.cash_flow_id = latest_income.cash_flow_id
go

select * from user_incomes
go


if object_id('dbo.debt_to_income_ratios') is not null
	drop view dbo.debt_to_income_ratios
go

create view debt_to_income_ratios as
	select 
			debt.users_id,
			round(debt.current_total_debt/(inc.discretionary_monthly_income *12),2) as debt_to_income_ratio
		from 
			dbo.user_debt debt
				join
			dbo.user_incomes inc on debt.users_id = inc.users_id
go

select * from debt_to_income_ratios order by debt_to_income_ratio desc