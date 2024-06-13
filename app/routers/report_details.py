from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from .. import crud, models, schemas
from ..deps import get_db

router = APIRouter()

@router.post("/", response_model=schemas.ReportDetail)
def create_report_detail(report_detail: schemas.ReportDetailCreate, db: Session = Depends(get_db)):
    return crud.create_report_detail(db=db, report_detail=report_detail)

@router.get("/", response_model=List[schemas.ReportDetail])
def read_report_details(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.get_report_details(db, skip=skip, limit=limit)

@router.get("/{report_detail_id}", response_model=schemas.ReportDetail)
def read_report_detail(report_detail_id: int, db: Session = Depends(get_db)):
    db_report_detail = crud.get_report_detail(db, report_detail_id=report_detail_id)
    if db_report_detail is None:
        raise HTTPException(status_code=404, detail="Report detail not found")
    return db_report_detail
