       IDENTIFICATION DIVISION.
       PROGRAM-ID.    PBEG005.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE
                             STATUS PRT-ST.
           SELECT ACCT-REC   ASSIGN TO DATEREC
                             STATUS ACCT-ST.
       DATA DIVISION.
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  PRINT-SEQ      PIC X(04).
           05  PRINT-AD       PIC X(15).
           05  PRINT-SOYAD    PIC X(15).
           05  PRINT-BDAY     PIC 9(08).
           05  PRINT-TODAY    PIC 9(08).
           05  PRINT-DIFF     PIC 9(05).

      *
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05 ACCT-SEQ       PIC X(04).
           05 ACCT-AD        PIC X(15).
           05 ACCT-SOYAD     PIC X(15).
           05 ACCT-BDAY      PIC 9(08).
           05 ACCT-TODAY     PIC 9(08).

      *
       WORKING-STORAGE SECTION.
       01  WS-WORK-AREA.
           05 PRT-ST            PIC 9(02).
              88 PRT-SUCCESS              VALUE 00 97.
           05 ACCT-ST           PIC 9(02).
              88 EOF-ACCT-REC             VALUE 10.
              88 ACCT-SUCCESS             VALUE 00 97.
           05 WS-DATE           PIC 9(07).
           05 WS-INT            PIC 9(07).

      *------------------
       PROCEDURE DIVISION.
      *------------------
        00000-MAIN.
           PERFORM H100-OPEN-FILES.
           PERFORM H200-PROCESS UNTIL EOF-ACCT-REC.
           PERFORM H300-CLOSE.
         00000-END. EXIT.
         
        H100-OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN OUTPUT PRINT-LINE.
           READ ACCT-REC.
        H100-END. EXIT.

        H200-PROCESS.
             COMPUTE WS-DATE = FUNCTION INTEGER-OF-DATE (ACCT-BDAY)
             COMPUTE WS-INT  = FUNCTION INTEGER-OF-DATE (ACCT-TODAY)
             MOVE ACCT-SEQ TO PRINT-SEQ
             MOVE ACCT-AD TO PRINT-AD
             MOVE ACCT-SOYAD TO PRINT-SOYAD
             MOVE ACCT-BDAY TO PRINT-BDAY
             COMPUTE PRINT-DIFF = WS-INT - WS-DATE
             WRITE PRINT-REC
             READ ACCT-REC.
        H200-END. EXIT.

        H300-CLOSE.
              CLOSE ACCT-REC.
              CLOSE PRINT-LINE.
              STOP RUN.
        H300-END. EXIT.
      *

