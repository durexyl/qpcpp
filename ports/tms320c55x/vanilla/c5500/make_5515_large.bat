@echo off
:: ==========================================================================
:: Product: QP/C++ buld for TMS320C55x, vanilla, C5500-compiler, large model
:: Last Updated for Version: 4.5.03
:: Date of the Last Update:  Jan 16, 2013
::
::                    Q u a n t u m     L e a P s
::                    ---------------------------
::                    innovating embedded systems
::
:: Copyright (C) 2002-2012 Quantum Leaps, LLC. All rights reserved.
::
:: This program is open source software: you can redistribute it and/or
:: modify it under the terms of the GNU General Public License as published
:: by the Free Software Foundation, either version 2 of the License, or
:: (at your option) any later version.
::
:: Alternatively, this program may be distributed and modified under the
:: terms of Quantum Leaps commercial licenses, which expressly supersede
:: the GNU General Public License and are specifically designed for
:: licensees interested in retaining the proprietary status of their code.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program. If not, see <http://www.gnu.org/licenses/>.
::
:: Contact information:
:: Quantum Leaps Web sites: http://www.quantum-leaps.com
::                          http://www.state-machine.com
:: e-mail:                  info@quantum-leaps.com
:: ==========================================================================
setlocal

:: adjust the following path to the location where you've installed
:: the TI CodeComposer/C5500 toolset...
::
set TI_C5500=C:\tools\TI\ccsv5\ccsv5\tools\compiler\c5500_4.4.1


:: Typically, you don't need to modify this file past this line -------------

set PATH=%TI_C5500%\bin;%PATH%

set CC=cl55
set ASM=acp55
set LIB=ar55

set QP_INCDIR=..\..\..\..\include
set QP_PRTDIR=.

:: Specify TMS320Cxx architecture
set TMS320_VER=5515

:: Specify memory model
set MEM_MODEL=large

if "%1"=="" (
    echo default selected
    set BINDIR=dbg
    set CCFLAGS=-v%TMS320_VER% --memory_model=%MEM_MODEL% -g --include_path="%TI_C5500%\include"
)
if "%1"=="rel" (
    echo rel selected
    set BINDIR=rel
    set CCFLAGS=-v%TMS320_VER% --memory_model=%MEM_MODEL% -oi0 --define=NDEBUG --include_path="%TI_C5500%\include"
)
if "%1"=="spy" (
    echo spy selected
    set BINDIR=spy
    set CCFLAGS=-v%TMS320_VER% --memory_model=%MEM_MODEL% -g --define=Q_SPY --include_path="%TI_C5500%\include"
)

set LIBDIR=%BINDIR%
set LIBFLAGS=a
mkdir %BINDIR%

erase %BINDIR%\qp%TMS320_VER%_%MEM_MODEL%.lib

:: QEP ----------------------------------------------------------------------
set SRCDIR=..\..\..\..\qep\source
set CCINC=--include_path=%QP_PRTDIR% --include_path=%QP_INCDIR% --include_path=%SRCDIR%

@echo on
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qep.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qfsm_ini.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qfsm_dis.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_ini.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_dis.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_top.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_in.cpp 

%LIB% %LIBFLAGS% %LIBDIR%\qp%TMS320_VER%_%MEM_MODEL%.lib %BINDIR%\qep.obj %BINDIR%\qfsm_ini.obj %BINDIR%\qfsm_dis.obj %BINDIR%\qhsm_ini.obj %BINDIR%\qhsm_dis.obj %BINDIR%\qhsm_top.obj %BINDIR%\qhsm_in.obj
@echo off

:: QF -----------------------------------------------------------------------
set SRCDIR=..\..\..\..\qf\source
set CCINC=--include_path=%QP_PRTDIR% --include_path=%QP_INCDIR% --include_path=%SRCDIR%

@echo on
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_defer.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_fifo.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_lifo.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_get_.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_sub.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_usub.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_usuba.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_fifo.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_get.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_init.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_lifo.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_act.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_gc.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_log2.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_new.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_pool.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_psini.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_pspub.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_pwr2.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_tick.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qmp_get.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qmp_init.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qmp_put.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_ctor.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_arm.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_darm.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_rarm.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_ctr.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qvanilla.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" src\qf_port.cpp

%LIB% %LIBFLAGS% %LIBDIR%\qp%TMS320_VER%_%MEM_MODEL%.lib %BINDIR%\qep.obj %BINDIR%\qfsm_ini.obj %BINDIR%\qfsm_dis.obj %BINDIR%\qhsm_ini.obj %BINDIR%\qhsm_dis.obj %BINDIR%\qhsm_top.obj %BINDIR%\qhsm_in.obj %BINDIR%\qa_defer.obj %BINDIR%\qa_fifo.obj %BINDIR%\qa_lifo.obj %BINDIR%\qa_get_.obj %BINDIR%\qa_sub.obj %BINDIR%\qa_usub.obj %BINDIR%\qa_usuba.obj %BINDIR%\qeq_fifo.obj %BINDIR%\qeq_get.obj %BINDIR%\qeq_init.obj %BINDIR%\qeq_lifo.obj %BINDIR%\qf_act.obj %BINDIR%\qf_gc.obj %BINDIR%\qf_log2.obj %BINDIR%\qf_new.obj %BINDIR%\qf_pool.obj %BINDIR%\qf_pspub.obj %BINDIR%\qf_pwr2.obj %BINDIR%\qf_tick.obj %BINDIR%\qmp_get.obj %BINDIR%\qmp_init.obj %BINDIR%\qmp_put.obj %BINDIR%\qte_ctor.obj %BINDIR%\qte_arm.obj %BINDIR%\qte_darm.obj %BINDIR%\qte_rarm.obj %BINDIR%\qte_ctr.obj %BINDIR%\qvanilla.obj %BINDIR%\qf_port.obj
@echo off

:: QS -----------------------------------------------------------------------
if not "%1"=="spy" goto clean

set SRCDIR=..\..\..\..\qs\source
set CCINC=--include_path=%QP_PRTDIR% --include_path=%QP_INCDIR% --include_path=%SRCDIR%

@echo on
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_blk.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_byte.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_f32.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_f64.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_mem.cpp
::%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_str.cpp
%CC% %CCFLAGS% %CCINC% --obj_directory="%QP_PRTDIR%\%BINDIR%" src\qs_port.cpp

%LIB% %LIBFLAGS% %LIBDIR%\qp%TMS320_VER%_%MEM_MODEL%.lib %BINDIR%\qs_port.obj
@echo off

:: --------------------------------------------------------------------------

:clean
@echo off

erase %BINDIR%\*.obj

endlocal