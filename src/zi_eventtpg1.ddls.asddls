@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO-Basis für Veranstaltungen'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_EventTPG1
  as select from ZR_EVENT
  composition [0..*] of ZI_RegistrationTPG1 as _Registrations
{
  key EventUuid,
      EventId,
      Title,
      Location,
      StartDate,
      EndDate,
      MaxParticipants,
      Status,
      cast(
        case Status
          when 'P' then 'Planned'
          when 'O' then 'Open'
          when 'C' then 'Closed'
          else 'Unknown'
        end as abap.char(10)
      ) as StatusText,
      Description,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      _Registrations
}
