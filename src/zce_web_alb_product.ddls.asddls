@EndUserText.label: 'Productos'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_COMSUME_WS_PROD'
define custom entity Zce_web_alb_product

{
  key Product         : abap.char( 10 );
      ProductType     : abap.char( 2 );
      ProductCategory : abap.char( 40 );
      @Semantics.amount.currencyCode: 'Currency'
      Price           : abap.curr( 16,2 );
      Currency        : abap.cuky( 5 );
      Supplier        : abap.char( 10 );
}
