#!/bin/bash

# Создание директорий
mkdir -p WB_data/{.venv,alembic/versions,app/api}

# Создание файлов с содержимым
cat <<EOL > WB_data/.env
DATABASE_URL=postgresql://myuser:mypassword@rc1a-abc12345xyz67890.mdb.yandexcloud.net:6432/mydatabase
EOL

cat <<EOL > WB_data/requirements.txt
fastapi
uvicorn
sqlalchemy
alembic
psycopg2-binary
pydantic
requests
python-dotenv
EOL

cat <<EOL > WB_data/alembic.ini
[alembic]
script_location = alembic

[loggers]
keys = root,sqlalchemy,alembic

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARN
handlers = console
qualname =

[logger_sqlalchemy]
level = WARN
handlers = console
qualname = sqlalchemy.engine
propagate = 0

[logger_alembic]
level = INFO
handlers = console
qualname = alembic
propagate = 0

[handler_console]
class = StreamHandler
args = (sys.stdout,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(levelname)-5.5s [%(name)s] %(message)s

[post_write_hooks]
EOL

cat <<EOL > WB_data/alembic/env.py
from logging.config import fileConfig
from sqlalchemy import engine_from_config
from sqlalchemy import pool
from alembic import context
import os
from dotenv import load_dotenv

# Load .env file
load_dotenv()

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
# This line sets up loggers basically.
fileConfig(config.config_file_name)

# add your model's MetaData object here
# for 'autogenerate' support
from app.models import Base
target_metadata = Base.metadata

# other values from the config, defined by the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline():
    """Run migrations in 'offline' mode.
    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well. By skipping the Engine creation
    we don't even need a DBAPI to be available.
    Calls to context.execute() here emit the given string to the
    script output.
    """
    url = os.getenv("DATABASE_URL")
    context.configure(
        url=url, target_metadata=target_metadata, literal_binds=True, dialect_opts={"paramstyle": "named"}
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    """Run migrations in 'online' mode.
    In this scenario we need to create an Engine
    and associate a connection with the context.
    """
    configuration = config.get_section(config.config_ini_section)
    configuration["sqlalchemy.url"] = os.getenv("DATABASE_URL")
    connectable = engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
EOL

cat <<EOL > WB_data/app/__init__.py
# This file can be empty or can contain package-level variables or imports
EOL

cat <<EOL > WB_data/app/main.py
from fastapi import FastAPI
from app.api import orders, stocks, sales
from app.database import engine
from app.models import Base

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(orders.router, prefix="/orders", tags=["orders"])
app.include_router(stocks.router, prefix="/stocks", tags=["stocks"])
app.include_router(sales.router, prefix="/sales", tags=["sales"])
EOL

cat <<EOL > WB_data/app/models.py
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
EOL

cat <<EOL > WB_data/app/crud.py
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
EOL

cat <<EOL > WB_data/app/schemas.py
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
EOL

cat <<EOL > WB_data/app/database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
EOL

cat <<EOL > WB_data/app/api/__init__.py
# This file can be empty or can contain package-level variables or imports
EOL

cat <<EOL > WB_data/app/api/orders.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.crud import get_orders, create_order
from app.schemas import Order, OrderCreate
from app.database import get_db

router = APIRouter()

@router.get("/", response_model=list[Order])
def read_orders(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    orders = get_orders(db, skip=skip, limit=limit)
    return orders

@router.post("/", response_model=Order)
def create_order_item(order: OrderCreate, db: Session = Depends(get_db)):
    return create_order(db, order)
EOL

cat <<EOL > WB_data/app/api/stocks.py
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
EOL

cat <<EOL > WB_data/app/api/sales.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.crud import get_sales, create_sale
from app.schemas import Sale, SaleCreate
from app.database import get_db

router = APIRouter()

@router.get("/", response_model=list[Sale])
def read_sales(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    sales = get_sales(db, skip=skip, limit=limit)
    return sales

@router.post("/", response_model=Sale)
def create_sale_item(sale: SaleCreate, db: Session = Depends(get_db)):
    return create_sale(db, sale)
EOL

# Установка прав на выполнение
chmod +x setup_project.sh

echo "Project setup script created. Run it with ./setup_project.sh"
