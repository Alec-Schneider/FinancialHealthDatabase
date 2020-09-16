# -*- coding: utf-8 -*-
"""
Created on Sun Aug 30 06:50:52 2020

@author: Alec
"""

import sqlalchemy as sql
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


# eng = sql.create_engine('mssql+pyodbc://ist-s-students.syr.edu/IST659_M401_afschnei?driver=SQL Server?Trusted_Connection=yes’')
eng = sql.create_engine('mssql+pyodbc://@VidCast64') # Connect using DSN
conn = eng.connect()


'''
####################################################

Track average monthly spending over time.

####################################################
'''

# SQL Server query
cash_flow_query = '''
select
    *,
    row_number() over (partition by cash_flow_updates.cash_flow_id order by 
                        cash_flow_updates.cash_flow_update_date desc) as RowNum 
from cash_flow_updates
        join
cash_flow on cash_flow.cash_flow_id = cash_flow_updates.cash_flow_id
'''

# Read the data into an DataFrame object, then filter on user 650
user_cfs = users_spending_inc = pd.read_sql(cash_flow_query, eng)
user650 = user_cfs[user_cfs['users_id'] == 650][['cash_flow_update_date', 'average_monthly_spending']]
user650.sort_values(by='cash_flow_update_date')


fig, ax = plt.subplots(1,1, figsize=(8,8))

ax.plot(user650.iloc[:,0], user650.iloc[:,1])

for index, row in user650.sort_values(by='cash_flow_update_date').iterrows():
    ax.text(row['cash_flow_update_date'], row['average_monthly_spending'], str(row['average_monthly_spending']), ha='center')

plt.title('Monthly Spending Over Time For User 650')
plt.xticks(rotation=30, ha='right')
fig.savefig('images\monthly_spending_user650.png');


def track_user_spending(userID, outdir=None):
    cash_flow_query = '''
    select
        *,
        row_number() over (partition by cash_flow_updates.cash_flow_id order by 
                            cash_flow_updates.cash_flow_update_date desc) as RowNum 
    from cash_flow_updates
            join
    cash_flow on cash_flow.cash_flow_id = cash_flow_updates.cash_flow_id
    '''
    
    # Read the data into an DataFrame object, then filter on user 650
    user_cfs = pd.read_sql(cash_flow_query, eng)
    user650 = user_cfs[user_cfs['users_id'] == userID][['cash_flow_update_date', 'average_monthly_spending']]
    user650.sort_values(by='cash_flow_update_date')
    
    
    fig, ax = plt.subplots(1,1, figsize=(8,8))
    
    ax.plot(user650.iloc[:,0], user650.iloc[:,1])
    
    for index, row in user650.sort_values(by='cash_flow_update_date').iterrows():
        ax.text(row['cash_flow_update_date'], row['average_monthly_spending'], str(row['average_monthly_spending']), ha='center')
    
    plt.title('Monthly Spending Over Time For User {0}'.format(userID))
    plt.xticks(rotation=30, ha='right')
    plt.show()
    fig.savefig('images\monthly_spending_user{0}.png'.format(userID));    
    fig.clf()
    plt.close(fig)



'''
####################################################

Spening to income ratios by gender

####################################################
'''


user_acct_query = '''
select 
    *, 
    dbo.spend_ratio(users_id) as spending_to_income
from users
order by spending_to_income desc'''


users_spending_inc = pd.read_sql(user_acct_query, eng)
males = users_spending_inc[users_spending_inc['gender'] == 'M']
females = users_spending_inc[users_spending_inc['gender'] == 'F']


fig, axes = plt.subplots(1, 2, figsize=(12,6))
sns.distplot(males['spending_to_income'], hist=False, rug=True, label='males', ax=axes[0])
axes[0].set_title('Percent Of Income Spent Per Month By Gender')
sns.distplot(females['spending_to_income'], hist=False, rug=True, label='females', ax=axes[1])
axes[1].set_title('Percent Of Income Spent Per Month By Gender ')
plt.savefig('images\spending_to_income_by_gender.png')



# Close out the connection
conn.close()