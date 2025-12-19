@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Anzeige-/Hilfssicht (Teilnehmer)'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true 
@UI.headerInfo: { 
    typeName: 'Participant', 
    typeNamePlural: 'Participants', 
    title.value: 'LastName', 
    description.value: 'Email' 
}
@Search.searchable: true 
define root view entity ZC_PARTICIPANTTPG1
  provider contract transactional_query
  as projection on ZI_ParticipantTPG1
{
  key ParticipantUuid,
      ParticipantId,

      @Search.defaultSearchElement: true
      FirstName,
      
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['LastName']
      LastName,
      
      Email,
      Phone,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt
}
