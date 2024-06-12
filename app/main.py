from fastapi import FastAPI
from app.api import orders, stocks, sales
from app.database import engine
from app.models import Base

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(orders.router, prefix="/orders", tags=["orders"])
app.include_router(stocks.router, prefix="/stocks", tags=["stocks"])
app.include_router(sales.router, prefix="/sales", tags=["sales"])
