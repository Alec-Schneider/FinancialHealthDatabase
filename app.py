from flask import Flask, render_template, redirect, url_for

app = Flask('__main__')


@app.route('/')
def login():
    return render_template('login.html')

@app.route('/login')
def user_login():
    return render_template('user_login.html')

if __name__ == '__main__':
        app.run(debug=True)