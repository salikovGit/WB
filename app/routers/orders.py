from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.crud import get_orders, create_order
from app.schemas import Order, OrderCreate
from app.database import get_db

router = APIRouter()

@router.get("/", response_model=list[Order])
def read_orders(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    orders = get_orders(db, skip=skip, limit=limit)
    print('orders')
    return orders

@router.post("/", response_model=Order)
def create_order_item(order: OrderCreate, db: Session = Depends(get_db)):
    return create_order(db, order)
