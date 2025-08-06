class zcl_comsume_ws_prod definition
  public


  final
  create public .

  public section.
    interfaces if_rap_query_provider.

    constants: mc_base_url              type string value 'https://sapes5.sapdevcenter.com/',
               mc_relative_service_root type string value '/sap/opu/odata/sap/zpdcds_srv/'.

    types t_bussines_data type zwsc_odata_prod=>tyt_sepmra_i_product_etype.
    types t_products_range type range of zwsc_odata_prod=>tys_sepmra_i_product_etype.
    interfaces if_oo_adt_classrun .
  protected section.
  private section.
    methods get_product
      importing
        it_filter_cod    type if_rap_query_filter=>tt_name_range_pairs optional
        top              type i optional
        skip             type i optional
      exporting
        et_bussines_data type t_bussines_data
      raising
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error.
endclass.



class zcl_comsume_ws_prod implementation.


  method if_oo_adt_classrun~main.
    data: business_data      type t_bussines_data,
          filters_conditions type if_rap_query_filter=>tt_name_range_pairs,
          range_table        type if_rap_query_filter=>tt_range_option.


    range_table = value #( ( sign = 'I'  Option = 'GE' Low = 'HT-1200' ) ).

    filters_conditions = value #( ( name = 'PRODUCT' range = range_table ) ).
    try.
        me->get_product(
          exporting
            it_filter_cod    = filters_conditions
            top              = 10
            skip             = 1
          importing
            et_bussines_data = business_data ).

        out->write( business_data ).

      catch cx_root into data(lx_exeption) .
        out->write(  cl_message_helper=>get_latest_t100_exception(  lx_exeption )->if_message~get_longtext(  ) ).

*     catch /iwbep/cx_cp_remote.
*     catch /iwbep/cx_gateway.
*     catch cx_web_http_client_error.
*     catch cx_http_dest_provider_error.

    endtry.
  endmethod.
  method get_product.

    data: lo_filter_factory   type ref to /iwbep/if_cp_filter_factory,
          lo_filter_node      type ref to /iwbep/if_cp_filter_node,
          lo_root_filter_node type ref to /iwbep/if_cp_filter_node.


    data: lo_http_client  type ref to if_web_http_client,
          lo_client_proxy type ref to /iwbep/if_cp_client_proxy,
          lo_request      type ref to /iwbep/if_cp_request_read_list,
          lo_response     type ref to /iwbep/if_cp_response_read_lst.


*      lt_business_data type table of zwsc_odata_prod=>tys_sepmra_i_product_etype,


    try.
        " Create http client
        data(lo_http_destination) = cl_http_destination_provider=>create_by_url( i_url = mc_base_url ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).


        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          exporting
             is_proxy_model_key       = value #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZWSC_ODATA_PROD'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = mc_relative_service_root ).

        assert lo_http_client is bound.


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'SEPMRA_I_PRODUCT_E' )->create_request_for_read( ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).

        loop at it_filter_cod into data(wa_cod).
          lo_filter_node = lo_filter_factory->create_by_range( iv_property_path = wa_cod-name
                                                               it_range         = wa_cod-range ).
          if lo_root_filter_node is initial.
            lo_root_filter_node = lo_filter_node.
          else.
            lo_root_filter_node = lo_root_filter_node->and( lo_filter_node ).
          endif.


        endloop.

        if lo_root_filter_node is not initial.
          lo_request->set_filter( lo_root_filter_node ).
        endif.

*lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'PRODUCT_TYPE'
*                                                        it_range             = lt_range_PRODUCT_TYPE ).

*lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
*
        if top > 0.
          lo_request->set_top( top ).
        endif.

        lo_request->set_skip( skip ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( importing et_business_data = et_bussines_data ).

      catch /iwbep/cx_cp_remote into data(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      catch /iwbep/cx_gateway into data(lx_gateway).
        " Handle Exception

      catch cx_web_http_client_error into data(lx_web_http_client_error).
        " Handle Exception
        raise shortdump lx_web_http_client_error.


    endtry.
  endmethod.

  method if_rap_query_provider~select.

  endmethod.

endclass.
