from fastapi import FastAPI
from .routers import stocks, sales, orders
from app.database import engine
from app.models import Base
from .routers import report_details

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(orders.router, prefix="/orders", tags=["orders"])
app.include_router(stocks.router, prefix="/stocks", tags=["stocks"])
app.include_router(sales.router, prefix="/sales", tags=["sales"])
app.include_router(report_details.router, prefix="/api/v5/supplier/reportDetailByPeriod", tags=["report_details"])


# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)