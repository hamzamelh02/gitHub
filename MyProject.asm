
_delayy:

;MyProject.c,30 :: 		void delayy(int time_ms) {
;MyProject.c,31 :: 		time=0;                 // Reset overflow counter
	CLRF       _time+0
	CLRF       _time+1
;MyProject.c,32 :: 		while (time < time_ms);
L_delayy0:
	MOVLW      128
	XORWF      _time+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_delayy_time_ms+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delayy55
	MOVF       FARG_delayy_time_ms+0, 0
	SUBWF      _time+0, 0
L__delayy55:
	BTFSC      STATUS+0, 0
	GOTO       L_delayy1
	GOTO       L_delayy0
L_delayy1:
;MyProject.c,33 :: 		}
L_end_delayy:
	RETURN
; end of _delayy

_CCPPWM_init:

;MyProject.c,36 :: 		void CCPPWM_init(){                  // Configure and CCP2 at 2ms period with 50% duty cycle
;MyProject.c,37 :: 		T2CON = 0x07;                    // Enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
	MOVLW      7
	MOVWF      T2CON+0
;MyProject.c,38 :: 		CCP2CON = 0x0C;                  // Enable PWM for CCP2
	MOVLW      12
	MOVWF      CCP2CON+0
;MyProject.c,39 :: 		PR2 = 250;                       // 250 counts = 8uS *250 = 2ms period
	MOVLW      250
	MOVWF      PR2+0
;MyProject.c,40 :: 		CCPR2L = 125;                    // Buffer where we are specifying the pulse width (duty cycle)
	MOVLW      125
	MOVWF      CCPR2L+0
;MyProject.c,41 :: 		}
L_end_CCPPWM_init:
	RETURN
; end of _CCPPWM_init

_Speed:

;MyProject.c,44 :: 		void Speed(int p){
;MyProject.c,45 :: 		CCPR2L = p;                  // PWM from RC1
	MOVF       FARG_Speed_p+0, 0
	MOVWF      CCPR2L+0
;MyProject.c,46 :: 		}
L_end_Speed:
	RETURN
; end of _Speed

_main:

;MyProject.c,58 :: 		void main() {
;MyProject.c,60 :: 		initialize();
	CALL       _initialize+0
;MyProject.c,67 :: 		ATD_init_A0();
	CALL       _ATD_init_A0+0
;MyProject.c,68 :: 		CCPPWM_init();
	CALL       _CCPPWM_init+0
;MyProject.c,69 :: 		b=0;
	CLRF       _b+0
	CLRF       _b+1
;MyProject.c,70 :: 		a=1;
	MOVLW      1
	MOVWF      _a+0
	MOVLW      0
	MOVWF      _a+1
;MyProject.c,71 :: 		while(1){
L_main2:
;MyProject.c,72 :: 		PORTD=PORTD & 0B11011111;
	MOVLW      223
	ANDWF      PORTD+0, 1
;MyProject.c,73 :: 		check_start();
	CALL       _check_start+0
;MyProject.c,75 :: 		while(b){
L_main4:
	MOVF       _b+0, 0
	IORWF      _b+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
;MyProject.c,76 :: 		PORTD=PORTD | 0B00100000;
	BSF        PORTD+0, 5
;MyProject.c,77 :: 		check_front_right();
	CALL       _check_front_right+0
;MyProject.c,78 :: 		check_start();
	CALL       _check_start+0
;MyProject.c,79 :: 		check_front_left();
	CALL       _check_front_left+0
;MyProject.c,80 :: 		check_start();
	CALL       _check_start+0
;MyProject.c,81 :: 		check_front();
	CALL       _check_front+0
;MyProject.c,82 :: 		check_start();
	CALL       _check_start+0
;MyProject.c,83 :: 		adjust_position();
	CALL       _adjust_position+0
;MyProject.c,84 :: 		check_start();
	CALL       _check_start+0
;MyProject.c,85 :: 		check_and_extinguish_fire();
	CALL       _check_and_extinguish_fire+0
;MyProject.c,86 :: 		check_start();
	CALL       _check_start+0
;MyProject.c,88 :: 		}
	GOTO       L_main4
L_main5:
;MyProject.c,90 :: 		}
	GOTO       L_main2
;MyProject.c,91 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_initialize:

;MyProject.c,95 :: 		void initialize(){
;MyProject.c,96 :: 		TRISA=0X01;
	MOVLW      1
	MOVWF      TRISA+0
;MyProject.c,97 :: 		TRISB=0X00;
	CLRF       TRISB+0
;MyProject.c,98 :: 		TRISC=0B10000000;
	MOVLW      128
	MOVWF      TRISC+0
;MyProject.c,99 :: 		TRISD=0B00001111;
	MOVLW      15
	MOVWF      TRISD+0
;MyProject.c,101 :: 		PORTA=0X00;
	CLRF       PORTA+0
;MyProject.c,102 :: 		PORTB=0X00;
	CLRF       PORTB+0
;MyProject.c,103 :: 		PORTC=0X00;
	CLRF       PORTC+0
;MyProject.c,104 :: 		PORTD=0X00;
	CLRF       PORTD+0
;MyProject.c,109 :: 		OPTION_REG = 0x87; // 32.8ms overflow
	MOVLW      135
	MOVWF      OPTION_REG+0
;MyProject.c,110 :: 		TMR0 = 0;
	CLRF       TMR0+0
;MyProject.c,114 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,115 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,116 :: 		H_L = 1;                // start high
	MOVLW      1
	MOVWF      _H_L+0
	MOVLW      0
	MOVWF      _H_L+1
;MyProject.c,117 :: 		CCP1CON = 0x08;        // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;MyProject.c,119 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;MyProject.c,121 :: 		INTCON = 0b11100000;         // Enable GIE, peripheral interrupts and TMR0 Interrupt
	MOVLW      224
	MOVWF      INTCON+0
;MyProject.c,122 :: 		PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;MyProject.c,123 :: 		CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
	MOVLW      7
	MOVWF      CCPR1H+0
;MyProject.c,124 :: 		CCPR1L = 2000;         // Value preset in a program to compare the TMR1L value to
	MOVLW      208
	MOVWF      CCPR1L+0
;MyProject.c,130 :: 		}
L_end_initialize:
	RETURN
; end of _initialize

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,136 :: 		void interrupt(){
;MyProject.c,137 :: 		if(INTCON & 0x04){// TMR0 Overflow interrupt, will get here every 32ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt6
;MyProject.c,139 :: 		time++;
	INCF       _time+0, 1
	BTFSC      STATUS+0, 2
	INCF       _time+1, 1
;MyProject.c,140 :: 		tick1++;
	INCF       _tick1+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tick1+1, 1
;MyProject.c,142 :: 		INTCON = INTCON & 0xFB;//Clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;MyProject.c,143 :: 		}
L_interrupt6:
;MyProject.c,144 :: 		if(PIR1 & 0x04){
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt7
;MyProject.c,145 :: 		if(a==1){                                           // CCP1 interrupt
	MOVLW      0
	XORWF      _a+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt62
	MOVLW      1
	XORWF      _a+0, 0
L__interrupt62:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;MyProject.c,146 :: 		if(H_L){                                // high
	MOVF       _H_L+0, 0
	IORWF      _H_L+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt9
;MyProject.c,147 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      _angle+1, 7
	MOVLW      255
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;MyProject.c,148 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;MyProject.c,149 :: 		H_L = 0;                      // next time low
	CLRF       _H_L+0
	CLRF       _H_L+1
;MyProject.c,150 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;MyProject.c,151 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,152 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,153 :: 		}
	GOTO       L_interrupt10
L_interrupt9:
;MyProject.c,155 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;MyProject.c,156 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;MyProject.c,157 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;MyProject.c,158 :: 		H_L = 1;                     //next time High
	MOVLW      1
	MOVWF      _H_L+0
	MOVLW      0
	MOVWF      _H_L+1
;MyProject.c,159 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,160 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,161 :: 		}  }else{
L_interrupt10:
	GOTO       L_interrupt11
L_interrupt8:
;MyProject.c,162 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;MyProject.c,163 :: 		}
L_interrupt11:
;MyProject.c,165 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;MyProject.c,166 :: 		}
L_interrupt7:
;MyProject.c,169 :: 		}
L_end_interrupt:
L__interrupt61:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_check_start:

;MyProject.c,173 :: 		void check_start(){
;MyProject.c,174 :: 		if(PORTD & 0B00001000){
	BTFSS      PORTD+0, 3
	GOTO       L_check_start12
;MyProject.c,175 :: 		b++;
	INCF       _b+0, 1
	BTFSC      STATUS+0, 2
	INCF       _b+1, 1
;MyProject.c,176 :: 		}
L_check_start12:
;MyProject.c,177 :: 		if(b%2==0){
	MOVLW      2
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _b+0, 0
	MOVWF      R0+0
	MOVF       _b+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_start64
	MOVLW      0
	XORWF      R0+0, 0
L__check_start64:
	BTFSS      STATUS+0, 2
	GOTO       L_check_start13
;MyProject.c,178 :: 		b=0;
	CLRF       _b+0
	CLRF       _b+1
;MyProject.c,179 :: 		}else{b=1;}
	GOTO       L_check_start14
L_check_start13:
	MOVLW      1
	MOVWF      _b+0
	MOVLW      0
	MOVWF      _b+1
L_check_start14:
;MyProject.c,182 :: 		}
L_end_check_start:
	RETURN
; end of _check_start

_ATD_init_A0:

;MyProject.c,183 :: 		void ATD_init_A0(){
;MyProject.c,184 :: 		ADCON0=0x41;           // ON, Channel 0, Fosc/16== 500KHz, Dont Go
	MOVLW      65
	MOVWF      ADCON0+0
;MyProject.c,185 :: 		ADCON1=0xCE;           // RA0 Analog, others are Digital, Right Allignment,
	MOVLW      206
	MOVWF      ADCON1+0
;MyProject.c,186 :: 		TRISA=0x01;
	MOVLW      1
	MOVWF      TRISA+0
;MyProject.c,188 :: 		}
L_end_ATD_init_A0:
	RETURN
; end of _ATD_init_A0

_ATD_read_A0:

;MyProject.c,190 :: 		int ATD_read_A0(){
;MyProject.c,191 :: 		ADCON0=ADCON0 | 0x04;  // GO
	BSF        ADCON0+0, 2
;MyProject.c,192 :: 		while(ADCON0&0x04);    // wait until DONE
L_ATD_read_A015:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read_A016
	GOTO       L_ATD_read_A015
L_ATD_read_A016:
;MyProject.c,193 :: 		return (ADRESH<<8)|ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;MyProject.c,195 :: 		}
L_end_ATD_read_A0:
	RETURN
; end of _ATD_read_A0

_check_front_right:

;MyProject.c,200 :: 		void check_front_right(){
;MyProject.c,202 :: 		if(PORTD & 0b00000001){
	BTFSS      PORTD+0, 0
	GOTO       L_check_front_right17
;MyProject.c,203 :: 		tick1 = 0;
	CLRF       _tick1+0
	CLRF       _tick1+1
;MyProject.c,205 :: 		while(!(PORTD & 0b00000100)){
L_check_front_right18:
	BTFSC      PORTD+0, 2
	GOTO       L_check_front_right19
;MyProject.c,208 :: 		if (tick1 >= turning_time_delay) break;
	MOVLW      128
	XORWF      _tick1+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _turning_time_delay+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_front_right68
	MOVF       _turning_time_delay+0, 0
	SUBWF      _tick1+0, 0
L__check_front_right68:
	BTFSS      STATUS+0, 0
	GOTO       L_check_front_right20
	GOTO       L_check_front_right19
L_check_front_right20:
;MyProject.c,210 :: 		move_right();
	CALL       _move_right+0
;MyProject.c,212 :: 		}
	GOTO       L_check_front_right18
L_check_front_right19:
;MyProject.c,213 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_check_front_right21:
	DECFSZ     R13+0, 1
	GOTO       L_check_front_right21
	DECFSZ     R12+0, 1
	GOTO       L_check_front_right21
	DECFSZ     R11+0, 1
	GOTO       L_check_front_right21
	NOP
;MyProject.c,215 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,216 :: 		}
L_check_front_right17:
;MyProject.c,217 :: 		}
L_end_check_front_right:
	RETURN
; end of _check_front_right

_check_front_left:

;MyProject.c,220 :: 		void check_front_left(){
;MyProject.c,222 :: 		if ((PORTD & 0b00000010)){
	BTFSS      PORTD+0, 1
	GOTO       L_check_front_left22
;MyProject.c,223 :: 		tick1 = 0;
	CLRF       _tick1+0
	CLRF       _tick1+1
;MyProject.c,225 :: 		while(!(PORTD & 0b00000100)){
L_check_front_left23:
	BTFSC      PORTD+0, 2
	GOTO       L_check_front_left24
;MyProject.c,227 :: 		if (tick1 >= turning_time_delay) break;
	MOVLW      128
	XORWF      _tick1+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _turning_time_delay+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_front_left70
	MOVF       _turning_time_delay+0, 0
	SUBWF      _tick1+0, 0
L__check_front_left70:
	BTFSS      STATUS+0, 0
	GOTO       L_check_front_left25
	GOTO       L_check_front_left24
L_check_front_left25:
;MyProject.c,228 :: 		move_left();
	CALL       _move_left+0
;MyProject.c,229 :: 		}
	GOTO       L_check_front_left23
L_check_front_left24:
;MyProject.c,231 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,232 :: 		}
L_check_front_left22:
;MyProject.c,233 :: 		}
L_end_check_front_left:
	RETURN
; end of _check_front_left

_check_front:

;MyProject.c,235 :: 		void check_front(){
;MyProject.c,236 :: 		while((PORTD & 0b00000100)){
L_check_front26:
	BTFSS      PORTD+0, 2
	GOTO       L_check_front27
;MyProject.c,237 :: 		sensor_voltage = ATD_read_A0();
	CALL       _ATD_read_A0+0
	MOVF       R0+0, 0
	MOVWF      _sensor_voltage+0
	MOVF       R0+1, 0
	MOVWF      _sensor_voltage+1
;MyProject.c,240 :: 		while(sensor_voltage <= 70 || sensor_voltage >= 400){
L_check_front28:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _sensor_voltage+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_front72
	MOVF       _sensor_voltage+0, 0
	SUBLW      70
L__check_front72:
	BTFSC      STATUS+0, 0
	GOTO       L__check_front52
	MOVLW      128
	XORWF      _sensor_voltage+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_front73
	MOVLW      144
	SUBWF      _sensor_voltage+0, 0
L__check_front73:
	BTFSC      STATUS+0, 0
	GOTO       L__check_front52
	GOTO       L_check_front29
L__check_front52:
;MyProject.c,241 :: 		sensor_voltage = ATD_read_A0();
	CALL       _ATD_read_A0+0
	MOVF       R0+0, 0
	MOVWF      _sensor_voltage+0
	MOVF       R0+1, 0
	MOVWF      _sensor_voltage+1
;MyProject.c,242 :: 		move_forward();
	CALL       _move_forward+0
;MyProject.c,243 :: 		distance=dist();
	CALL       _dist+0
	MOVF       R0+0, 0
	MOVWF      _distance+0
	MOVF       R0+1, 0
	MOVWF      _distance+1
;MyProject.c,244 :: 		if(distance<20){
	MOVLW      128
	XORWF      R0+1, 0
	MOVWF      R2+0
	MOVLW      128
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_front74
	MOVLW      20
	SUBWF      R0+0, 0
L__check_front74:
	BTFSC      STATUS+0, 0
	GOTO       L_check_front32
;MyProject.c,245 :: 		move_right();
	CALL       _move_right+0
;MyProject.c,246 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,247 :: 		move_forward();
	CALL       _move_forward+0
;MyProject.c,248 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,249 :: 		move_left();
	CALL       _move_left+0
;MyProject.c,250 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,251 :: 		move_forward();
	CALL       _move_forward+0
;MyProject.c,252 :: 		}else{move_forward();}
	GOTO       L_check_front33
L_check_front32:
	CALL       _move_forward+0
L_check_front33:
;MyProject.c,253 :: 		if(!(PORTD & 0b00000100)){break;}
	BTFSC      PORTD+0, 2
	GOTO       L_check_front34
	GOTO       L_check_front29
L_check_front34:
;MyProject.c,254 :: 		}
	GOTO       L_check_front28
L_check_front29:
;MyProject.c,255 :: 		if(sensor_voltage <= 70) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _sensor_voltage+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_front75
	MOVF       _sensor_voltage+0, 0
	SUBLW      70
L__check_front75:
	BTFSS      STATUS+0, 0
	GOTO       L_check_front35
	GOTO       L_check_front27
L_check_front35:
;MyProject.c,256 :: 		if((PORTD & 0b00000100)){break;} }
	BTFSS      PORTD+0, 2
	GOTO       L_check_front36
	GOTO       L_check_front27
L_check_front36:
	GOTO       L_check_front26
L_check_front27:
;MyProject.c,259 :: 		delayy(100);
	MOVLW      100
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      0
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,260 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,261 :: 		}
L_end_check_front:
	RETURN
; end of _check_front

_stop_moving:

;MyProject.c,265 :: 		void stop_moving(){
;MyProject.c,266 :: 		PORTB = PORTB & 0b11110000;
	MOVLW      240
	ANDWF      PORTB+0, 1
;MyProject.c,267 :: 		Speed(0);
	CLRF       FARG_Speed_p+0
	CLRF       FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,268 :: 		}
L_end_stop_moving:
	RETURN
; end of _stop_moving

_move_left:

;MyProject.c,272 :: 		void move_left(){
;MyProject.c,273 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,275 :: 		Speed(90);
	MOVLW      90
	MOVWF      FARG_Speed_p+0
	MOVLW      0
	MOVWF      FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,277 :: 		PORTB = PORTB | 0b00000001;
	BSF        PORTB+0, 0
;MyProject.c,278 :: 		PORTB = PORTB | 0b00001000;
	BSF        PORTB+0, 3
;MyProject.c,279 :: 		}
L_end_move_left:
	RETURN
; end of _move_left

_move_right:

;MyProject.c,281 :: 		void move_right(){
;MyProject.c,282 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,283 :: 		Speed(90);
	MOVLW      90
	MOVWF      FARG_Speed_p+0
	MOVLW      0
	MOVWF      FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,284 :: 		PORTB = PORTB | 0b00000100;
	BSF        PORTB+0, 2
;MyProject.c,285 :: 		PORTB = PORTB | 0b00000010;
	BSF        PORTB+0, 1
;MyProject.c,286 :: 		}
L_end_move_right:
	RETURN
; end of _move_right

_move_forward:

;MyProject.c,288 :: 		void move_forward(){
;MyProject.c,289 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,290 :: 		Speed(170);
	MOVLW      170
	MOVWF      FARG_Speed_p+0
	CLRF       FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,292 :: 		PORTB = PORTB |0b00000001;
	BSF        PORTB+0, 0
;MyProject.c,293 :: 		PORTB = PORTB |0b00000100;
	BSF        PORTB+0, 2
;MyProject.c,295 :: 		}
L_end_move_forward:
	RETURN
; end of _move_forward

_move_backwards:

;MyProject.c,297 :: 		void move_backwards(){
;MyProject.c,298 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,299 :: 		Speed(90);
	MOVLW      90
	MOVWF      FARG_Speed_p+0
	MOVLW      0
	MOVWF      FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,300 :: 		PORTB = PORTB | 0b00000010;
	BSF        PORTB+0, 1
;MyProject.c,301 :: 		PORTB = PORTB | 0b00001000;
	BSF        PORTB+0, 3
;MyProject.c,302 :: 		}
L_end_move_backwards:
	RETURN
; end of _move_backwards

_adjust_position:

;MyProject.c,306 :: 		void adjust_position(){
;MyProject.c,307 :: 		while((PORTD & 0b00000100)){
L_adjust_position37:
	BTFSS      PORTD+0, 2
	GOTO       L_adjust_position38
;MyProject.c,308 :: 		sensor_voltage = ATD_read_A0();
	CALL       _ATD_read_A0+0
	MOVF       R0+0, 0
	MOVWF      _sensor_voltage+0
	MOVF       R0+1, 0
	MOVWF      _sensor_voltage+1
;MyProject.c,309 :: 		while(sensor_voltage < 70){
L_adjust_position39:
	MOVLW      128
	XORWF      _sensor_voltage+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__adjust_position82
	MOVLW      70
	SUBWF      _sensor_voltage+0, 0
L__adjust_position82:
	BTFSC      STATUS+0, 0
	GOTO       L_adjust_position40
;MyProject.c,310 :: 		move_backwards();
	CALL       _move_backwards+0
;MyProject.c,311 :: 		sensor_voltage = ATD_read_A0();
	CALL       _ATD_read_A0+0
	MOVF       R0+0, 0
	MOVWF      _sensor_voltage+0
	MOVF       R0+1, 0
	MOVWF      _sensor_voltage+1
;MyProject.c,312 :: 		}
	GOTO       L_adjust_position39
L_adjust_position40:
;MyProject.c,314 :: 		if( sensor_voltage>=70) {break;}
	MOVLW      128
	XORWF      _sensor_voltage+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__adjust_position83
	MOVLW      70
	SUBWF      _sensor_voltage+0, 0
L__adjust_position83:
	BTFSS      STATUS+0, 0
	GOTO       L_adjust_position41
	GOTO       L_adjust_position38
L_adjust_position41:
;MyProject.c,315 :: 		if(!(PORTD & 0b00000100)){break;}
	BTFSC      PORTD+0, 2
	GOTO       L_adjust_position42
	GOTO       L_adjust_position38
L_adjust_position42:
;MyProject.c,316 :: 		}
	GOTO       L_adjust_position37
L_adjust_position38:
;MyProject.c,317 :: 		delayy(100);
	MOVLW      100
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      0
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,318 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,319 :: 		}
L_end_adjust_position:
	RETURN
; end of _adjust_position

_check_and_extinguish_fire:

;MyProject.c,324 :: 		void check_and_extinguish_fire(){
;MyProject.c,327 :: 		sensor_voltage = ATD_read_A0();
	CALL       _ATD_read_A0+0
	MOVF       R0+0, 0
	MOVWF      _sensor_voltage+0
	MOVF       R0+1, 0
	MOVWF      _sensor_voltage+1
;MyProject.c,328 :: 		while ((PORTD & 0b00000100))
L_check_and_extinguish_fire43:
	BTFSS      PORTD+0, 2
	GOTO       L_check_and_extinguish_fire44
;MyProject.c,331 :: 		if(sensor_voltage <70 || sensor_voltage > 400) break;
	MOVLW      128
	XORWF      _sensor_voltage+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_and_extinguish_fire85
	MOVLW      70
	SUBWF      _sensor_voltage+0, 0
L__check_and_extinguish_fire85:
	BTFSS      STATUS+0, 0
	GOTO       L__check_and_extinguish_fire53
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      _sensor_voltage+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_and_extinguish_fire86
	MOVF       _sensor_voltage+0, 0
	SUBLW      144
L__check_and_extinguish_fire86:
	BTFSS      STATUS+0, 0
	GOTO       L__check_and_extinguish_fire53
	GOTO       L_check_and_extinguish_fire47
L__check_and_extinguish_fire53:
	GOTO       L_check_and_extinguish_fire44
L_check_and_extinguish_fire47:
;MyProject.c,332 :: 		stop_moving();
	CALL       _stop_moving+0
;MyProject.c,333 :: 		a=1;
	MOVLW      1
	MOVWF      _a+0
	MOVLW      0
	MOVWF      _a+1
;MyProject.c,335 :: 		PORTB=PORTB|0B10000000;
	BSF        PORTB+0, 7
;MyProject.c,336 :: 		angle = 1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;MyProject.c,337 :: 		PORTD=PORTD | 0B11000000;
	MOVLW      192
	IORWF      PORTD+0, 1
;MyProject.c,338 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,341 :: 		angle = 3500;
	MOVLW      172
	MOVWF      _angle+0
	MOVLW      13
	MOVWF      _angle+1
;MyProject.c,342 :: 		PORTD=PORTD & 0B00111111;
	MOVLW      63
	ANDWF      PORTD+0, 1
;MyProject.c,343 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,345 :: 		angle = 1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;MyProject.c,346 :: 		PORTD=PORTD | 0B11000000;
	MOVLW      192
	IORWF      PORTD+0, 1
;MyProject.c,347 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,348 :: 		angle = 3500;
	MOVLW      172
	MOVWF      _angle+0
	MOVLW      13
	MOVWF      _angle+1
;MyProject.c,349 :: 		PORTD=PORTD & 0B00111111;
	MOVLW      63
	ANDWF      PORTD+0, 1
;MyProject.c,350 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,351 :: 		angle = 1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;MyProject.c,352 :: 		PORTD=PORTD | 0B11000000;
	MOVLW      192
	IORWF      PORTD+0, 1
;MyProject.c,353 :: 		}
	GOTO       L_check_and_extinguish_fire43
L_check_and_extinguish_fire44:
;MyProject.c,354 :: 		PORTD=PORTD & 0B00111111;
	MOVLW      63
	ANDWF      PORTD+0, 1
;MyProject.c,356 :: 		angle =  2250;
	MOVLW      202
	MOVWF      _angle+0
	MOVLW      8
	MOVWF      _angle+1
;MyProject.c,357 :: 		delayy(2000);
	MOVLW      208
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      7
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,358 :: 		a=0;
	CLRF       _a+0
	CLRF       _a+1
;MyProject.c,359 :: 		PORTB=PORTB & 0B01111111;
	MOVLW      127
	ANDWF      PORTB+0, 1
;MyProject.c,360 :: 		}
L_end_check_and_extinguish_fire:
	RETURN
; end of _check_and_extinguish_fire

_dist:

;MyProject.c,363 :: 		int dist(){
;MyProject.c,364 :: 		int d = 0;
	CLRF       dist_d_L0+0
	CLRF       dist_d_L0+1
;MyProject.c,365 :: 		T1CON = 0x10; // Use internal clock, no prescaler
	MOVLW      16
	MOVWF      T1CON+0
;MyProject.c,366 :: 		delayy(100);
	MOVLW      100
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      0
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,369 :: 		TMR1H = 0;                  // Reset Timer1
	CLRF       TMR1H+0
;MyProject.c,370 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,372 :: 		PORTC = PORTC | 0b01000000; // Trigger HIGH
	BSF        PORTC+0, 6
;MyProject.c,373 :: 		delayy(1);               // 1 ms delay
	MOVLW      1
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      0
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,374 :: 		PORTC = PORTC & 0b10111111; // Trigger LOW
	MOVLW      191
	ANDWF      PORTC+0, 1
;MyProject.c,376 :: 		while (!(PORTC & 0b10000000));
L_dist48:
	BTFSC      PORTC+0, 7
	GOTO       L_dist49
	GOTO       L_dist48
L_dist49:
;MyProject.c,379 :: 		T1CON = T1CON | 0b00000001; // Start Timer
	BSF        T1CON+0, 0
;MyProject.c,382 :: 		while (PORTC & 0b10000000);
L_dist50:
	BTFSS      PORTC+0, 7
	GOTO       L_dist51
	GOTO       L_dist50
L_dist51:
;MyProject.c,385 :: 		T1CON = T1CON & 0b11111110; // Stop Timer
	MOVLW      254
	ANDWF      T1CON+0, 1
;MyProject.c,387 :: 		d = (TMR1L | (TMR1H << 8)); // Read Timer1 value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      dist_d_L0+0
	MOVF       R0+1, 0
	MOVWF      dist_d_L0+1
;MyProject.c,388 :: 		d = d / 58.82;           // Convert time to distance (cm)
	CALL       _int2double+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      dist_d_L0+0
	MOVF       R0+1, 0
	MOVWF      dist_d_L0+1
;MyProject.c,391 :: 		delayy(10);
	MOVLW      10
	MOVWF      FARG_delayy_time_ms+0
	MOVLW      0
	MOVWF      FARG_delayy_time_ms+1
	CALL       _delayy+0
;MyProject.c,392 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;MyProject.c,393 :: 		return d;
	MOVF       dist_d_L0+0, 0
	MOVWF      R0+0
	MOVF       dist_d_L0+1, 0
	MOVWF      R0+1
;MyProject.c,395 :: 		}
L_end_dist:
	RETURN
; end of _dist
