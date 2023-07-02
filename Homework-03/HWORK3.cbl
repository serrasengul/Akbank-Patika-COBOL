       IDENTIFICATION DIVISION.
       PROGRAM-ID.    ODEV003.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE     ASSIGN TO IDXFILE
                               ORGANIZATION INDEXED
                               ACCESS RANDOM
                               RECORD KEY IDX-KEY
                               STATUS IDX-ST.
           SELECT DVZDB-FILE   ASSIGN TO DVZFILE
                               ORGANIZATION IS INDEXED
                               ACCESS RANDOM
                               RECORD KEY IS DVZ-ID
                               STATUS DVZ-ST.
           SELECT PRINT-LINE   ASSIGN TO PRTLINE
                               STATUS PRT-ST.
           SELECT ACCT-REC     ASSIGN TO ACCTFILE
                               STATUS ACCT-ST.
       DATA DIVISION.
       FILE SECTION.
       FD  IDX-FILE
           DATA RECORD IS IDX-REC.
       01  IDX-REC.
           03  IDX-KEY.
               05 IDX-ID        PIC S9(5) COMP-3.
               05 IDX-DVZ       PIC S9(3) COMP.
           03  IDX-NAME         PIC X(05).
           03  FILLER           PIC X(10).
           03  IDX-LNAME        PIC X(07).
           03  FILLER           PIC X(08).
           03  IDX-DATE         PIC S9(7) COMP-3.
           03  IDX-BALANCE      PIC S9(15) COMP-3.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  PRINT-ID         PIC X(05).
           05  FILLER           PIC X(05) VALUE SPACE.
           05  PRINT-DVZ        PIC X(03).
           05  FILLER           PIC X(05) VALUE SPACE.
           05  PRINT-NAME       PIC X(05).
           05  FILLER           PIC X(05) VALUE SPACE.
           05  PRINT-LNAME      PIC X(07).
           05  FILLER           PIC X(05) VALUE SPACE.
           05  PRINT-DATE       PIC X(08).
           05  FILLER           PIC X(05) VALUE SPACE.
           05  PRINT-BALANCE    PIC x(15).
      *
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05 ACCT-ID         PIC X(05).
           05 ACCT-DVZ        PIC X(3).
           05 FILLER          PIC X(10).
           05 ACCT-BALANCE    PIC 9(03).
      *
       FD  DVZDB-FILE.
       01  DVZ-FIELDS.
           05 DVZ-ID          PIC 9(03).
           05 DVZ-SPACES      PIC X(10).
           05 DVZ-NAME        PIC X(03).
      *
       WORKING-STORAGE SECTION.
       01  WS-WORK-AREA.
           05 WS-INDEX               PIC 9(02).
           05 IDX-ST                 PIC 9(02).
              88 IDX-SUCCESS                   VALUE 00 97.
              88 IDX-NOT-FOUND                 VALUE 23.
           05 PRT-ST                 PIC 9(02).
              88 PRT-SUCCESS                   VALUE 00 97.
           05 DVZ-ST                 PIC 9(02).
              88 DVZ-SUCCESS                   VALUE 00 97.
           05 ACCT-ST                PIC 9(02).
              88 EOF-ACCT-REC                  VALUE 10.
              88 ACCT-SUCCESS                  VALUE 00 97.
           05 INT-DATE               PIC 9(07).
           05 GREG-DATE              PIC 9(08).
       01  WS-VSAM-REC.
              05 R-IDX-ID            PIC S9(05) COMP-3.
              05 R-IDX-DVZ           PIC S9(03) COMP.
              05 R-IDX-AD            PIC X(30).
              05 R-IDX-TARIH         PIC S9(7)  COMP-3.
              05 R-IDX-TUTAR         PIC S9(15) COMP-3.

      *------------------
       PROCEDURE DIVISION.
      *------------------
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H150-PRINT-HEADERS
           PERFORM H200-READ-FIRST
           PERFORM H201-READ-NEXT-RECORD UNTIL EOF-ACCT-REC.
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.

       H100-OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN INPUT  IDX-FILE.
           OPEN OUTPUT PRINT-LINE .
           OPEN INPUT  DVZDB-FILE.
           IF (NOT IDX-SUCCESS)
           DISPLAY 'UNABLE TO OPEN INPFILE: ' IDX-ST
           MOVE IDX-ST  TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF (NOT ACCT-SUCCESS)
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ACCT-ST
           MOVE ACCT-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF (NOT PRT-SUCCESS)
           DISPLAY 'UNABLE TO OPEN OUTFILE: ' PRT-ST
           MOVE PRT-ST  TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           IF (NOT DVZ-SUCCESS)
              DISPLAY 'UNABLE TO OPEN DVZDB FILE: ' DVZ-ST
              MOVE DVZ-ST TO RETURN-CODE
              PERFORM H999-PROGRAM-EXIT
           END-IF.
       H100-END. EXIT.

       H150-PRINT-HEADERS.
           PERFORM FILL-WITH-SPACES.
           MOVE 'ID'         TO PRINT-ID.
           MOVE 'DVZ'        TO PRINT-DVZ.
           MOVE 'Ad'         TO PRINT-NAME.
           MOVE 'Soy ad'     TO PRINT-LNAME.
           MOVE 'Tarih'      TO PRINT-DATE.
           MOVE 'Tutar'      TO PRINT-BALANCE.
           WRITE PRINT-REC.
         H150-END. EXIT.

       H200-READ-FIRST.
           READ ACCT-REC.
           PERFORM H210-READ-DVZDB.
           IF (NOT ACCT-SUCCESS)
           DISPLAY 'UNABLE TO READ INPFILE: ' ACCT-ST
           MOVE ACCT-ST  TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           COMPUTE IDX-ID = FUNCTION NUMVAL-C (ACCT-ID)
           COMPUTE IDX-DVZ = FUNCTION NUMVAL (ACCT-DVZ)
           READ IDX-FILE KEY IDX-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM WRITE-RECORD.
       H200-END. EXIT.

       H210-READ-DVZDB.
           IF (NOT DVZ-SUCCESS)
                DISPLAY 'UNABLE TO READ DVZDB FILE: ' DVZ-ST
           END-IF.
           COMPUTE DVZ-ID = FUNCTION NUMVAL (ACCT-DVZ)
           READ DVZDB-FILE KEY DVZ-ID
           INVALID KEY DISPLAY
                       "There is no DVZ matching with ID : " ACCT-DVZ
           NOT INVALID KEY PERFORM TRIM-DVZ-NAME
           END-READ.
       H210-END. EXIT.


       H201-READ-NEXT-RECORD.
           READ ACCT-REC.
           COMPUTE IDX-ID = FUNCTION NUMVAL-C (ACCT-ID)
           COMPUTE IDX-DVZ = FUNCTION NUMVAL (ACCT-DVZ)
           PERFORM H210-READ-DVZDB.
           READ IDX-FILE KEY IDX-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM WRITE-RECORD.
       H201-END. EXIT.

       DATE-CONVERT.
           COMPUTE INT-DATE = FUNCTION INTEGER-OF-DAY(IDX-DATE)
           COMPUTE GREG-DATE = FUNCTION DATE-OF-INTEGER(INT-DATE).
       DATE-END. EXIT.

       FILL-WITH-SPACES.
           MOVE SPACES TO PRINT-REC.
       FILL-END. EXIT.

       WRNG-RECORD.
               DISPLAY "There is no record matching with ID : " IDX-ID.
       WRNG-END. EXIT.

       TRIM-DVZ-NAME.
           MOVE DVZ-NAME TO PRINT-DVZ.
       TRIM-END. EXIT.

         UPDATE-BALANCE.
              ADD ACCT-BALANCE TO IDX-BALANCE.

       WRITE-RECORD.
           PERFORM DATE-CONVERT.
           PERFORM FILL-WITH-SPACES.
           PERFORM UPDATE-BALANCE.
           DISPLAY "ID : " IDX-LNAME.
           WRITE PRINT-REC.
       WRITE-END. EXIT.

       H999-PROGRAM-EXIT.
           CLOSE ACCT-REC.
           CLOSE IDX-FILE.
           CLOSE PRINT-LINE.
           GOBACK.
       H999-EXIT.

      *
