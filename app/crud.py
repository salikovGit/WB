from sqlalchemy.orm import Session
from .models import Order, Stock, Sale
from .schemas import OrderCreate, StockCreate, SaleCreate

def get_orders(db: Session, skip: int = 0, limit: int = 10):
    return db.query(Order).offset(skip).limit(limit).all()

def create_order(db: Session, order: OrderCreate):
    db_order = Order(**order.dict())
    db.add(db_order)
    db.commit()
    db.refresh(db_order)
    return db_order

def get_stocks(db: Session, skip: int = 0, limit: int = 10):
    return db.query(Stock).offset(skip).limit(limit).all()

def create_stock(db: Session, stock: StockCreate):
    db_stock = Stock(**stock.dict())
    db.add(db_stock)
    db.commit()
    db.refresh(db_stock)
    return db_stock

def get_sales(db: Session, skip: int = 0, limit: int = 10):
    return db.query(Sale).offset(skip).limit(limit).all()

def create_sale(db: Session, sale: SaleCreate):
    db_sale = Sale(**sale.dict())
    db.add(db_sale)
    db.commit()
    db.refresh(db_sale)
    return db_sale
