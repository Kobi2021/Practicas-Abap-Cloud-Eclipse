@AbapCatalog.sqlViewName: 'ZCDSVIEW_EQUIPOS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Equipos'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDSVIEW_EQUIPOS2
  as select from ztab_equipos
{
  key cod_team     as CodTeam,
      name_team    as NameTeam,
      user_crea    as UserCrea,
      date_crea    as DateCrea,
      user_changed as UserChanged,
      date_changed as DateChanged
}
