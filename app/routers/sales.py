from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.crud import get_sales, create_sale
from app.schemas import Sale, SaleCreate
from app.database import get_db

router = APIRouter()

@router.get("/", response_model=list[Sale])
def read_sales(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    sales = get_sales(db, skip=skip, limit=limit)
    print(sales)
    return sales

@router.post("/", response_model=Sale)
def create_sale_item(sale: SaleCreate, db: Session = Depends(get_db)):
    print('sales_bd')
    return create_sale(db, sale)
