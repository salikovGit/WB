from pydantic import BaseModel
from datetime import datetime

class OrderBase(BaseModel):
    date: datetime
    order_id: str
    total: float

class OrderCreate(OrderBase):
    pass

class Order(OrderBase):
    id: int

    class Config:
        orm_mode = True

class StockBase(BaseModel):
    product_id: str
    quantity: int

class StockCreate(StockBase):
    pass

class Stock(StockBase):
    id: int

    class Config:
        orm_mode = True

class SaleBase(BaseModel):
    sale_id: str
    amount: float
    date: datetime

class SaleCreate(SaleBase):
    pass

class Sale(SaleBase):
    id: int

    class Config:
        orm_mode = True
