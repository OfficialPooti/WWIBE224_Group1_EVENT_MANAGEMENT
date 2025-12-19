@EndUserText.label: 'Child-Objekt (Teilnahmen)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZC_REGISTRATIONTPG1 
  as projection on ZI_RegistrationTPG1
{
    key RegistrationUuid,
    
    @EndUserText.label: 'Registration ID'
    RegistrationId,
    
    @EndUserText.label: 'Event UUID'
    EventUuid,
 
    @Consumption.valueHelpDefinition: [ {
        entity: {
            name: 'ZC_PARTICIPANTTP',
            element: 'ParticipantUuid'
        }
    } ]
    @ObjectModel.text.association: '_Participant'
    @EndUserText.label: 'Select Participant'
    ParticipantUuid,

    @EndUserText.label: 'Status'
    Status,
    
    @EndUserText.label: 'Remarks'
    @Search.defaultSearchElement: true 
    Remarks,
    
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
       
    @EndUserText.label: 'First Name'
    @Search.defaultSearchElement: true 
    @Search.fuzzinessThreshold: 0.7
    _Participant.FirstName as FirstName,
    
    @EndUserText.label: 'Last Name'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    _Participant.LastName as LastName,
    
    @EndUserText.label: 'Event'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    _Event.Title as EventTitle,
    
    _Event : redirected to parent ZC_EVENTTPG1,


    _Participant : redirected to ZC_PARTICIPANTTPG1
}
