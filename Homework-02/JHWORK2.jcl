//PBEG005J JOB 1,NOTIFY=&SYSUID
//***************************************************/
//* Copyright Contributors to the COBOL Programming Course
//* SPDX-License-Identifier: CC-BY-4.0
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(PBEG005),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(PBEG005),DISP=SHR
//***************************************************/
// IF RC < 5 THEN
//***************************************************/
//RUN     EXEC PGM=PBEG005
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//DATEREC   DD DSN=&SYSUID..QSAM.HW2B,DISP=SHR
//*PRTLINE   DD SYSOUT=*,OUTLIM=15000
//PRTLINE   DD DSN=&SYSUID..QSAM.HW2OUT,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=50,BLKSIZE=0),UNIT=3390
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
