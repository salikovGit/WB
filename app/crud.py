from sqlalchemy.orm import Session
from . import models, schemas

def get_report_detail(db: Session, report_detail_id: int):
    return db.query(models.ReportDetail).filter(models.ReportDetail.id == report_detail_id).first()

def get_report_details(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.ReportDetail).offset(skip).limit(limit).all()

def create_report_detail(db: Session, report_detail: schemas.ReportDetailCreate):
    db_report_detail = models.ReportDetail(**report_detail.dict())
    db.add(db_report_detail)
    db.commit()
    db.refresh(db_report_detail)
    return db_report_detail
