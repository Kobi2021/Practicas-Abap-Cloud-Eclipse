CLASS zcl_example01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_example01 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    out->write( 'Prueba Nro.05' ).
  ENDMETHOD.

ENDCLASS.
