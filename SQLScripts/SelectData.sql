use IST659_M401_afschnei;

-- Select all from the users table
select * from users;


-- Select all from the cash_flow table
select * from cash_flow;


-- Get all updates from the cash_flow_updates
Select * from cash_flow_updates;


-- Select all from the account_category table
select * from account_category;


-- Select all from the account_category table
select * from account_type;


-- Select all from the account tables
select * from accounts;

-- Select all the account updates
select * from account_updates;


-- Select all login information
select * from user_login

select count(account_id) from accounts;

-- Select all from the users and cash_flow tables
select
	*
from
	users
join
	cash_flow on users.users_id = cash_flow.users_id;


-- select the latest cash_flow_update_date of each user
select
	users.users_id,
	users.first_name,
	users.last_name,
	max(cash_flow_update_date) as latest_update,
	users.creation_date
from
	cash_flow
		join
	cash_flow_updates on cash_flow.cash_flow_id = cash_flow_updates.cash_flow_id
		join
	users on cash_flow.users_id = users.users_id
group by users.first_name, users.last_name, users.users_id, users.creation_date


/*
	select all the datav from the users and the cash_flow tables.
	But base it on the latest cash_flow_update date.
*/
select
	*
from
	users
join
	cash_flow on users.users_id = cash_flow.users_id
join
	-- return the latest cash_flow_update for each user
	(
		select
			users_id,
			max(cash_flow_update_date) as latest_update
		from
			cash_flow
		group by users_id
	) as new_cf
	on users.users_id = new_cf.users_id
		and new_cf.latest_update = cash_flow.cash_flow_update_date;


-- select all the account, account type, and account category_info
select
	*
from
	accounts a
join
	account_type atype on a.account_type_id = atype.account_type_id
join
	account_category acat on atype.account_category_id = acat.account_category_id
;

select
	*,
	round(a.balance / a.repayment_term,2) as monthly_payment2
from
	accounts a
join
	account_type atype on a.account_type_id = atype.account_type_id
join
	account_category acat on atype.account_category_id = acat.account_category_id
WHERE a.account_type_id in (1, 2, 3, 4, 5);


-- update brokerage account to account_category = 2
update account_type
set account_category_id = 2
where account_type_id = 7



/* return a table of the cash_flows ordered by their creation_date
		and a row_number field of each cash flow in order to pick the latest one
		*/
select
	*,
	row_number() over (partition by cash_flow_updates.cash_flow_id order by 
				cash_flow_updates.cash_flow_update_date desc) as RowNum 
from 
	cash_flow_updates
		join
	cash_flow on cash_flow.cash_flow_id = cash_flow_updates.cash_flow_id