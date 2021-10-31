

-- Function to return the  Debt to Income ratio for users


-- get the latest income for each user with a cash_flow
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


if object_id('dbo.user_debt_to_income') is not null
	drop function dbo.user_debt_to_income
go

/*
	Find the debt to income ratio of every user
	with debt accounts and a cash flow in the 
	database.
*/

create function dbo.user_debt_to_income(@userID int)
returns decimal(6,2) as
begin
	declare @returnVal decimal(6,2)
	/* 
		return a view that calculates the debt to income 
		ratio for each user. Find only ratio given for the
		passed userID.
	*/
	select 
		@returnVal = debt_to_income_ratio
	from 
		dbo.debt_to_income_ratios
	where users_id = @userID
	return @returnVal
end
go

-- Run the function for all users
select
	users_id,
	first_name,
	last_name,
	dbo.user_debt_to_income(users_id) as debt_to_income_ratio
from
	users
order by debt_to_income_ratio desc
go



if object_id('dbo.spend_ratio') is not null
	drop function dbo.spend_ratio
go

create function dbo.spend_ratio(@userID int)
returns decimal(6,2) as
begin
	declare @returnVal decimal(6,2)
	
	select
		@returnVal = round(average_monthly_spending / discretionary_monthly_income, 2)*100
	from
		dbo.current_cash_flows curr_cf
			join
		cash_flow on curr_cf.cash_flow_id = cash_flow.cash_flow_id
	where cash_flow.users_id = @userID
	return @returnVal
end
go

select
	*,
	dbo.spend_ratio(users_id) as spending_to_income_percent
from
	users
order by spending_to_income_percent desc	