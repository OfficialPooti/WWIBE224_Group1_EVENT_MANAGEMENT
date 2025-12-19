CLASS zcm_eventg1 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS start_in_past              TYPE symsgno VALUE '001'.
    CONSTANTS end_before_start           TYPE symsgno VALUE '002'.
    CONSTANTS max_participants_exceeded  TYPE symsgno VALUE '003'.

ENDCLASS.


CLASS zcm_eventg1 IMPLEMENTATION.
ENDCLASS.

