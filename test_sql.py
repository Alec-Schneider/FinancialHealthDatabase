from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base

engine = create_engine('mssql+pyodbc://ist-s-students.syr.edu/IST659_M401_afschnei?driver=SQL Server?Trusted_Connection=yes', convert_unicode=True, echo=False)
Base = declarative_base()
Base.metadata.reflect(engine)


from sqlalchemy.orm import relationship, backref

class Users(Base):
    __table__ = Base.metadata.tables['users']

class Accounts(Base):
    __table__ = Base.metadata.tables['accounts']

class AccountUpdates(Base):
    __table__ = Base.metadata.tables['account_updates']

if __name__ == '__main__':
    from sqlalchemy.orm import scoped_session, sessionmaker, Query
    db_session = scoped_session(sessionmaker(bind=engine))
    for item in db_session.query(Users.users_id, Users.first_name, Users.last_name):
        print(item)
    for item in db_session.query(AccountUpdates.account_update_id):
        print(item)