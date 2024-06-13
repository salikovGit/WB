from pydantic import BaseModel
from typing import List, Optional


class ReportDetailBase(BaseModel):
    realizationreport_id: int
    date_from: str
    date_to: str
    create_dt: str
    currency_name: str
    suppliercontract_code: str
    rrd_id: int
    gi_id: int
    subject_name: str
    nm_id: int
    brand_name: str
    sa_name: str
    ts_name: str
    barcode: str
    doc_type_name: str
    quantity: int
    retail_price: float
    retail_amount: float
    sale_percent: float
    commission_percent: float
    office_name: str
    supplier_oper_name: str
    order_dt: str
    sale_dt: str
    rr_dt: str
    shk_id: int
    retail_price_withdisc_rub: float
    delivery_amount: float
    return_amount: float
    delivery_rub: float
    gi_box_type_name: str
    product_discount_for_report: float
    supplier_promo: float
    rid: int
    ppvz_spp_prc: float
    ppvz_kvw_prc_base: float
    ppvz_kvw_prc: float
    sup_rating_prc_up: float
    is_kgvp_v2: int
    ppvz_sales_commission: float
    ppvz_for_pay: float
    ppvz_reward: float
    acquiring_fee: float
    acquiring_bank: str
    ppvz_vw: float
    ppvz_vw_nds: float
    ppvz_office_id: int
    ppvz_office_name: str
    ppvz_supplier_id: int
    ppvz_supplier_name: str
    ppvz_inn: str
    declaration_number: str
    bonus_type_name: str
    sticker_id: int
    site_country: str
    penalty: float
    additional_payment: float
    rebill_logistic_cost: float
    rebill_logistic_org: str
    kiz: str
    srid: int


class ReportDetailCreate(ReportDetailBase):
    pass


class ReportDetail(ReportDetailBase):
    id: int

    class Config:
        orm_mode = True
