@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO-Basis für Teilnehmer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_ParticipantTPG1 // <-- HIER IST 'root' HINZUGEFÜGT
  as select from ZR_PARTICIPANT
{
  key ParticipantUuid as ParticipantUuid,
      ParticipantId    as ParticipantId,
      FirstName        as FirstName,
      LastName         as LastName,
      Email            as Email,
      Phone            as Phone,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt
}
