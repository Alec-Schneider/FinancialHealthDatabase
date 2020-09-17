-- Procedures

-- Create a new user and enter their login info into the user_login table
create procedure new_user(@fname varchar(50), @lname varchar(50), @mname varchar(50) = Null, 
							@dob date, @ss varchar(11), @email varchar(150), @gender char(1),
							@pass varchar(25))
as
begin
	-- insert new user into the users table
	insert into users
		(first_name, last_name, middle_name, date_of_birth, social_security, email, gender)
	values
		(@fname, @lname, @mname, @dob, @ss, @email, @gender)
	
	-- insert login information into user_login
	insert into user_login
		(users_id, pass)
	values
		(@@identity, @pass)

end
go

exec new_user 'Jon', 'Hyman', Null, '1/27/1989', '798-22-1231' , 'jhy@gmail.com', 'M', '123xcvdfsd'

select * from users where first_name = 'Jon' and last_name = 'Hyman'


select 
	* 
from 
	user_login
where users_id = (select users_id from users where first_name = 'Jon' and last_name = 'Hyman')
go


-- Create procedure to update accounts
create procedure update_account(@acct_id int, @bal decimal(9,2), @rate decimal(4,2) = Null, @rate_type varchar(8) = Null, 
								@term int = Null)
as
begin
	-- update the information provided
	insert into account_updates
		(account_id ,balance, annual_interest_rate, interest_rate_type,
		repayment_term)
	values
		(@acct_id, @bal, @rate, @rate_type, @term)
		
end
go

select account_id, count(*) from account_updates group by account_id

select * from account_updates where account_id = 1589

exec update_account @acct_id=1589, @bal=343322.1

select * from account_updates where account_id = 1589
go


-- Create procedure to update cash flow of a user
create procedure update_cash_flow(@cf_id int, @income decimal(8,2), @spend decimal(8,2))
as
begin
	-- insert new cash flow update
	insert into cash_flow_updates
		(cash_flow_id, discretionary_monthly_income, average_monthly_spending)
	values
		(@cf_id, @income, @spend)

end
go


select cash_flow_id, count(*) from cash_flow_updates group by cash_flow_id

select * from cash_flow_updates where cash_flow_id = 593

exec update_cash_flow 593, 15000, 10000

select * from cash_flow_updates where cash_flow_id = 593
go


-- update a user's password
create procedure update_password(@user_id int, @pass varchar(25))
as
begin
	-- update the user's login password
	update 
		user_login
	set
		pass = @pass
	where
		users_id = @user_id

end
go


select top 5 * from user_login

exec update_password 1, icecold23

select top 5 * from user_login
go


-- create an account 
create procedure create_account(@users_id int, @acc_type_name varchar(30), @bal decimal(9,2), @rate decimal(4,2) = Null, 
								@rate_type varchar(8) = Null, @term int = Null)
as
begin
	-- begin transaction
	begin try
		begin transaction
			-- declare account id to be defined later
			declare @acct_id int
			-- return the account type id to enter into the accounts table
			declare @acc_type int = (select account_type_id 
										from account_type 
										where account_type_name = @acc_type_name)
			-- create the account in the accounts table
			insert into accounts
				(account_type_id, users_id)
			values
				(@acc_type, @users_id)
			-- set the row identity to account is
			set @acct_id = @@identity
			-- execute the account update procedure to enter the account info
			exec update_account @acct_id=@acct_id, @bal=@bal, @rate=@rate, 
								@rate_type=@rate_type, @term=@term
		if @@TRANCOUNT > 0
			commit

	end try

	begin catch
		
		if @@TRANCOUNT > 0
			rollback

		SELECT 
			ERROR_NUMBER() AS ErrorNumber, 
			ERROR_MESSAGE() AS ErrorMessage
	end catch
end
go

select * from account_type

select * from current_accounts

select * from user_investment

exec create_account @users_id=1, @acc_type_name='Brokerage', @bal=45000

select top 1 * from accounts order by account_id desc

select * from current_accounts where account_id = (select top 1 
														account_id 
													from accounts 
													order by account_id desc)