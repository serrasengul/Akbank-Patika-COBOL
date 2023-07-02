//ODEV003J JOB 1,NOTIFY=&SYSUID
//***************************************************/
//* Copyright Contributors to the COBOL Programming Course
//* SPDX-License-Identifier: CC-BY-4.0
//***************************************************/
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95622.QSAM.DE NONVSAM
  IF LASTCC LE 08 THEN SET MAXCC = 00
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(ODEV003),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(ODEV003),DISP=SHR
//***************************************************/
// IF RC < 5 THEN
//***************************************************/
//RUN     EXEC PGM=ODEV003
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//IDXFILE   DD DSN=&SYSUID..VSAM.CC,DISP=SHR
//DVZFILE   DD DSN=&SYSUID..VSAM.DVZDB,DISP=SHR
//ACCTFILE  DD DSN=&SYSUID..QSAM.INP,DISP=SHR
//*PRTLINE   DD SYSOUT=*,OUTLIM=15000
//PRTLINE   DD DSN=&SYSUID..QSAM.DE,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=68,BLKSIZE=0),UNIT=3390
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
