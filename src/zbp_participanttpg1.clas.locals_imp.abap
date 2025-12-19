CLASS lhc_participant DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS determineparticipantid FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Participant~DetermineParticipantId.

    METHODS determineadmindata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Participant~DetermineAdminData.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Participant RESULT result.


ENDCLASS.

CLASS lhc_participant IMPLEMENTATION.

  METHOD determineparticipantid.
    SELECT MAX( participant_id ) FROM zparticipant_g1 INTO @DATA(max_id).
    IF max_id IS INITIAL.
      max_id = 0.
    ENDIF.
    DATA(new_id) = max_id + 1.

    MODIFY ENTITY IN LOCAL MODE ZI_PARTICIPANTtpg1
      UPDATE FIELDS ( ParticipantId )
      WITH VALUE #( FOR key IN keys
                      ( %tky = key-%tky ParticipantId = new_id ) ).
  ENDMETHOD.

  METHOD determineadmindata.

    DATA current_user TYPE syuname.
    current_user = sy-uname.

    DATA current_timestamp TYPE abp_lastchange_tstmpl.
    GET TIME STAMP FIELD current_timestamp.

    MODIFY ENTITIES OF ZI_PARTICIPANTtpg1 IN LOCAL MODE
      ENTITY Participant
      UPDATE FIELDS ( CreatedBy CreatedAt LastChangedBy LastChangedAt )
      WITH VALUE #( FOR key IN keys
                      ( %tky = key-%tky
                        CreatedBy = current_user
                        CreatedAt = current_timestamp
                        LastChangedBy = current_user
                        LastChangedAt = current_timestamp
                      ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
