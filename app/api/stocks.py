from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.crud import get_stocks, create_stock
from app.schemas import Stock, StockCreate
from app.database import get_db

router = APIRouter()

@router.get("/", response_model=list[Stock])
def read_stocks(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    stocks = get_stocks(db, skip=skip, limit=limit)
    return stocks

@router.post("/", response_model=Stock)
def create_stock_item(stock: StockCreate, db: Session = Depends(get_db)):
    return create_stock(db, stock)
