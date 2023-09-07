#===============================================================================
#
# __        ____  ____   ____ ___  _  __  ______  ______  
# \ \      / / /_| ___| / ___( _ )/ |/ /_/ ___\ \/ / __ ) 
#  \ \ /\ / / '_ \___ \| |   / _ \| | '_ \___ \\  /|  _ \ 
#   \ V  V /| (_) |__) | |__| (_) | | (_) |__) /  \| |_) |
#   _\_/\_/__\___/____/ \____\___/|_|\___/____/_/\_\____/ 
#  / ___|  _ \  ___ _ __ ___   ___                        
# | |   | | | |/ _ \ '_ ` _ \ / _ \                       
# | |___| |_| |  __/ | | | | | (_) |                      
#  \____|____/ \___|_| |_| |_|\___/                       
#                                                         
#-------------------------------------------------------------------------------
# Copyright (C)2019 Andrew Jacobs.
# All rights reserved.
#
# This work is made available under the terms of the Creative Commons
# Attribution-NonCommercial-ShareAlike 4.0 International license. Open the
# following URL to see the details.
#
# http://creativecommons.org/licenses/by-nc-sa/4.0/
#
#===============================================================================
# Notes:
#
#-------------------------------------------------------------------------------

AS		=	wdc816as

ASFLAGS	=	-G -LW
 
CC		=	wdc816cc

CCFLAGS	=	-BS $(OPTIM) $(MODEL) -DUSING_816

MODEL	= 	-MS

OPTIM	= 	-SOP -PE

LD		=	wdcln

LDFLAGS	=	-G -T -C0300

RM		=	erase

#-------------------------------------------------------------------------------

.asm.obj:
	$(AS) $(ASFLAGS) $< -obuild/$@ -Kbuild/$@.lst

.c.obj:
	$(CC) $(CCFLAGS) $< -obuild/$@
	
#===============================================================================


ASMS	=	01_boot.asm

SRCS	=	90_demo.c 50_w65c816sxb.c 20_stdio.c

OBJ     =   build/90_demo.obj build/50_w65c816sxb.obj build/20_stdio.obj build/01_boot.obj 

OBJS	=	$(ASMS:.asm=.obj) $(SRCS:.c=.obj)

LIBS	=	-LMS -LCS

all:		demo.bin

clean:
		$(RM) *.obj 2> NUL
		$(RM) *.64k 2> NUL
		$(RM) *.bin 2> NUL
		$(RM) *.lst 2> NUL
		$(RM) *.s28 2> NUL
		$(RM) *.map 2> NUL
		$(RM) *.sym 2> NUL
		$(RM) *.tmp 2> NUL
		$(RM) *.bnk 2> NUL
		$(RM) /Q /F build\* 2> NUL		
		$(RM) /Q /F bin\* 2> NUL		

demo.s28:	$(OBJS)
	$(LD) -G -HM28 $(LDFLAGS) -O$@ $(OBJ) $(LIBS)
	
demo.bin:	$(OBJS)
	$(LD) -G -HZ $(LDFLAGS) -Obin\$@ $(OBJ) $(LIBS)
	
demo.64k:	$(OBJS)
	$(LD) -G -HB $(LDFLAGS) -O$@ $(OBJ) $(LIBS)
	
#===============================================================================

w65c816sxb.h:	w65c816.h w65c22.h w65c21.h w65c51.h

demo.obj:	demo.c w65c816sxb.h

w65c816sxb.obj:	w65c816sxb.c w65c816sxb.h

stdio.obj:	stdio.c w65c816sxb.h