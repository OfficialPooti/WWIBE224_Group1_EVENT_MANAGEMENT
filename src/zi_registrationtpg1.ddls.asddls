@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO-Basis für Teilnahmen'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RegistrationTPG1
  as select from ZR_REGISTRATION
  association to parent ZI_EVENTTPG1       as _Event       on $projection.EventUuid = _Event.EventUuid
  association [1..1] to ZI_ParticipantTPG1 as _Participant on $projection.ParticipantUuid = _Participant.ParticipantUuid
{
  key RegistrationUuid as RegistrationUuid,
      RegistrationId    as RegistrationId,
      EventUuid         as EventUuid,
      ParticipantUuid   as ParticipantUuid,
      Status            as Status,
      Remarks           as Remarks,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _Event,
      _Participant
}
