use IST659_M401_afschnei;


if object_id('dbo.account') is not null
	drop table dbo.account;
if object_id('dbo.account_type') is not null
	drop table dbo.account_type;
if object_id('dbo.account_category') is not null
	drop table dbo.account_category;
if object_id('dbo.cash_flow') is not null
	drop table dbo.cash_flow;
if object_id('dbo.users') is not null
	drop table dbo.users;


create table users(
	users_id int identity,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	middle_name varchar(50),
	date_of_birth date not null,
	social_security varchar(11) not null,
	email varchar(150) not null,
	gender char(1) not null,
	creation_date datetime not null default GetDate(), 
	-- Constraints
	constraint users_pk primary key (users_id),
	constraint u1_users unique (social_security),
	constraint u2_users unique (email)
);


create table account_category(
	account_category_id int identity,
	account_category_name varchar(20) not null,
	constraint account_category_pk primary key (account_category_id),
	constraint account_category_u1 unique (account_category_name)
);


create table account_type(
	account_type_id int identity,
	account_type_name varchar(30) not null,
	account_category_id int not null,
	constraint account_type_pk primary key (account_type_id),
	constraint account_type_fk1 foreign key (account_category_id) 
		references account_category(account_category_id),
	constraint account_type_u1 unique (account_type_name)
);


create table account(
	account_id int identity,
	balance decimal(9,2) not null,
	annual_interest_rate decimal(4,2),
	interest_rate_type varchar(8),
	repayment_term int,
	monthly_payment as (balance * (1 + (annual_interest_rate / 100 / 12))) / repayment_term,
	account_update_date datetime not null default GetDate(),
	account_type_id int not null,
	users_id int not null, 
	constraint account_pk primary key (account_id),
	constraint account_fk1 foreign key (account_type_id) 
		references account_type(account_type_id),
	constraint account_fk2 foreign key (users_id) 
		references users(users_id)
);


create table cash_flow(
	cash_flow_id int identity,
	discretionary_monthly_income decimal(8,2) not null,
	average_monthly_spending decimal(8, 2) not null,
	cash_flow_update_date datetime not null default GetDate(),
	users_id int not null,
	constraint cash_flow_pk primary key (cash_flow_id),
	constraint cash_flow_fk1 foreign key (users_id)
		references users(users_id)
);
