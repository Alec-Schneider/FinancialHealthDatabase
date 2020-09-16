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
