from flask import Flask, render_template, redirect, url_for, request
from flask_sqlalchemy import SQLAlchemy
import sqlalchemy as sqlalc

app = Flask('__main__')

# eng = sql.create_engine('mssql+pyodbc://@VidCast64') # Connect using DSN
app.config['SQLALCHEMY_DATABASE_URI'] = 'mssql+pyodbc://ist-s-students.syr.edu/IST659_M401_afschnei?driver=SQL Server?Trusted_Connection=yes'
_db = SQLAlchemy(app)


# class Accounts(db.Model):
#     __table__ = db.metadata.tables['Accounts']



@app.route('/')
def login():
    return render_template('login.html')


@app.route('/login')
def user_login():
    return render_template('user_login.html')


@app.route('/create_user', methods=['GET', 'POST'])
def create_user():
    if request.form:
        print(request.form)
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        middle_name = request.form.get('middle_name')
        dob = request.form.get('dob')
        social = request.form.get('social_security')
        email = request.form.get('email')
        gender = request.form.get('gender')
        password = request.form.get('password')
        _db.session.execute(sqlalc.text('EXEC new_user @fname=:first, @lname=:last, @mname=:mid, \
                                        @dob=:dob, @ss=:ss, @email=:email, @gender=:gender, @pass=:password'),
                                        {
                                            'first': first_name,
                                            'last': last_name,
                                            'mid': middle_name,
                                            'dob': dob,
                                            'ss': social,
                                            'email': email,
                                            'gender': gender,
                                            'password': password
                                        })
        _db.session.commit()
    return render_template('create_user.html')


@app.route('/create_account', methods=['GET', 'POST'])
def create_account():
    '''
    
    '''
    if request.form:
        print(request.form)
        users_id = request.form.get("users_id", type=int)
        acct_type = request.form.get("acct_type", type=str)
        balance = request.form.get("balance", type=float)
        rate = request.form.get("rate", type=float) if request.form.get("rate") else sqlalc.null()
        rate_type = request.form.get("rate_type", type=str) if request.form.get("rate_type", type=str) != 'None' else sqlalc.null()
        pay_term = request.form.get("pay_term", type=int) if request.form.get("pay_term") else sqlalc.null()
        print({
                                        'users_id': users_id,
                                        'acct_type': acct_type,
                                        'bal': balance,
                                        'rate': rate,
                                        'rate_type':rate_type,
                                        'term': pay_term
                                        })
        if acct_type.lower() in ('mortgage', 'heloc', 'student', 'personal', 'auto' ):

            _db.session.execute(sqlalc.text('EXEC create_account @users_id=:users_id,  @acc_type_name=:acct_type, @bal=:bal, \
                                            @rate=:rate, @rate_type=:rate_type, @term=:term'), 
                                            {
                                            'users_id': users_id,
                                            'acct_type': acct_type,
                                            'bal': balance,
                                            'rate': rate,
                                            'rate_type':rate_type,
                                            'term': pay_term
                                            }
                                            )
        elif acct_type.lower() in ('savings', 'certificate of deposit', 'credit card'):
            _db.session.execute(sqlalc.text('EXEC create_account @users_id=:users_id,  @acc_type_name=:acct_type, @bal=:bal, \
                                            @rate=:rate, @rate_type=:rate_type'), 
                                            {
                                            'users_id': users_id,
                                            'acct_type': acct_type,
                                            'bal': balance,
                                            'rate': rate,
                                            'rate_type':rate_type
                                            }
                                            )
        elif acct_type.lower() in ('checking', '401k', 'ira', 'roth ira', 'pension', 'brokerage'):
            _db.session.execute(sqlalc.text('EXEC create_account @users_id=:users_id,  @acc_type_name=:acct_type, @bal=:bal'), 
                                            {
                                            'users_id': users_id,
                                            'acct_type': acct_type,
                                            'bal': balance
                                            }
                                            )
        _db.session.commit()
    return render_template('create_account.html')


if __name__ == '__main__':
        app.run(debug=True)