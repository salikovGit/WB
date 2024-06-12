from sqlalchemy import Column, Integer, String, Float, DateTime
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Order(Base):
    __tablename__ = 'orders'

    id = Column(Integer, primary_key=True, index=True)
    date = Column(DateTime)
    order_id = Column(String, index=True)
    total = Column(Float)

class Stock(Base):
    __tablename__ = 'stocks'

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(String, index=True)
    quantity = Column(Integer)

class Sale(Base):
    __tablename__ = 'sales'

    id = Column(Integer, primary_key=True, index=True)
    sale_id = Column(String, index=True)
    amount = Column(Float)
    date = Column(DateTime)
