class zcl_02_add_data_tab definition
  public
  final
  create public .

  public section.

  interfaces if_oo_adt_classrun.
  protected section.
  private section.
endclass.



class zcl_02_add_data_tab implementation.
  method if_oo_adt_classrun~main.

  out->write( 'Adding Travel Data...' ).
  delete from zlgl_travel_alb.

  insert zlgl_travel_alb
  from ( select from /dmo/travel fields
             uuid( ) as travel_uuid,
             travel_id,
             agency_id,
             customer_id,
             begin_date,
             end_date,
             booking_fee,
             total_price,
             currency_code,
             description,
             case status when 'B' then 'A'
                         when 'P' then 'O'
                         when 'N' then 'O'
                         else 'X' end as overall_status,
             createdby as local_created_by,
             createdat as local_created_at,
             lastchangedby as local_last_chaged_by,
             lastchangedat as last_changed_at ).



    out->write( |{  sy-dbcnt } filas Adicionandas..| ).
     endmethod.

endclass.
