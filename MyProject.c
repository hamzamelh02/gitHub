//PUMP PIN RB7


int tick;
int tick1;
int sensor_voltage;
int H_L;

int angle;
int distance;
int a;
int b;
int time;
int turning_time_delay = 5000;

void initialize();
void interrupt();

void stop_moving();
void move_left();
void move_right();
void move_forward();
void move_backwards();
void water_pump_ON();
void water_pump_OFF();
void adjust_position();
void check_and_extinguish_fire();
int dist();

void delayy(int time_ms) {
    time=0;                 // Reset overflow counter
    while (time < time_ms);
}


void CCPPWM_init(){                  // Configure and CCP2 at 2ms period with 50% duty cycle
        T2CON = 0x07;                    // Enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
        CCP2CON = 0x0C;                  // Enable PWM for CCP2
        PR2 = 250;                       // 250 counts = 8uS *250 = 2ms period
        CCPR2L = 125;                    // Buffer where we are specifying the pulse width (duty cycle)
}


void Speed(int p){
       CCPR2L = p;                  // PWM from RC1
}



void ATD_init_A0();
 int ATD_read_A0();

void check_front_right();
void check_front_left();
void check_front();
void check_start();

void main() {

     initialize();






     ATD_init_A0();
     CCPPWM_init();
     b=0;
     a=1;
     while(1){
        PORTD=PORTD & 0B11011111;
       check_start();

             while(b){
             PORTD=PORTD | 0B00100000;
              check_front_right();
              check_start();
              check_front_left();
              check_start();
              check_front();
              check_start();
              adjust_position();
              check_start();
              check_and_extinguish_fire();
              check_start();

 }

               }
}



void initialize(){
TRISA=0X01;
TRISB=0X00;
TRISC=0B10000000;
TRISD=0B00001111;

PORTA=0X00;
PORTB=0X00;
PORTC=0X00;
PORTD=0X00;



//For Timer 0
OPTION_REG = 0x87; // 32.8ms overflow
TMR0 = 0;



TMR1H = 0;
TMR1L = 0;
H_L = 1;                // start high
CCP1CON = 0x08;        // Compare mode, set output on match

T1CON = 0x01;

INTCON = 0b11100000;         // Enable GIE, peripheral interrupts and TMR0 Interrupt
PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
CCPR1L = 2000;         // Value preset in a program to compare the TMR1L value to





}





void interrupt(){
    if(INTCON & 0x04){// TMR0 Overflow interrupt, will get here every 32ms

       time++;
       tick1++;

       INTCON = INTCON & 0xFB;//Clear T0IF
       }
if(PIR1 & 0x04){
       if(a==1){                                           // CCP1 interrupt
             if(H_L){                                // high
                       CCPR1H = angle >> 8;
                       CCPR1L = angle;
                       H_L = 0;                      // next time low
                       CCP1CON = 0x09;              // compare mode, clear output on match
                       TMR1H = 0;
                       TMR1L = 0;
             }
             else{                                          //low
                       CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
                       CCPR1L = (40000 - angle);
                       CCP1CON = 0x08;             // compare mode, set output on match
                       H_L = 1;                     //next time High
                       TMR1H = 0;
                       TMR1L = 0;
             }  }else{
              PIR1 = PIR1&0xFB;
             }

             PIR1 = PIR1&0xFB;
       }


}



void check_start(){
 if(PORTD & 0B00001000){
       b++;
     }
     if(b%2==0){
     b=0;
     }else{b=1;}


}
void ATD_init_A0(){
ADCON0=0x41;           // ON, Channel 0, Fosc/16== 500KHz, Dont Go
      ADCON1=0xCE;           // RA0 Analog, others are Digital, Right Allignment,
      TRISA=0x01;

}

int ATD_read_A0(){
ADCON0=ADCON0 | 0x04;  // GO
      while(ADCON0&0x04);    // wait until DONE
      return (ADRESH<<8)|ADRESL;

}




 void check_front_right(){
 // read port b4 : right flame sensor
if(PORTD & 0b00000001){
    tick1 = 0;
    // read port b7 : front sensor until detects fire
    while(!(PORTD & 0b00000100)){

    // if it turns more than the turning_th stop (turning_th is time)
    if (tick1 >= turning_time_delay) break;
    // move right
    move_right();

    }
    delay_ms(100);
    // stop moving
stop_moving();
}
 }


void check_front_left(){
// read port b5 : left flame sensor
if ((PORTD & 0b00000010)){
     tick1 = 0;
    // read port b7 : front sensor until detects fire
    while(!(PORTD & 0b00000100)){
      // move left
      if (tick1 >= turning_time_delay) break;
      move_left();
      }
// stop moving
stop_moving();
}
}

void check_front(){
while((PORTD & 0b00000100)){
sensor_voltage = ATD_read_A0();

  // while flame detected approach it untill specified flame strength
 while(sensor_voltage <= 70 || sensor_voltage >= 400){
 sensor_voltage = ATD_read_A0();
 move_forward();
 distance=dist();
 if(distance<20){
 move_right();
 delayy(2000);
 move_forward();
 delayy(2000);
 move_left();
 delayy(2000);
 move_forward();
 }else{move_forward();}
  if(!(PORTD & 0b00000100)){break;}
 }
 if(sensor_voltage <= 70) {break;}
 if((PORTD & 0b00000100)){break;} }


  delayy(100);
 stop_moving();
}



void stop_moving(){
     PORTB = PORTB & 0b11110000;
     Speed(0);
}



void move_left(){
        stop_moving();

     Speed(90);

      PORTB = PORTB | 0b00000001;
      PORTB = PORTB | 0b00001000;
}

void move_right(){
stop_moving();
     Speed(90);
    PORTB = PORTB | 0b00000100;
     PORTB = PORTB | 0b00000010;
}

void move_forward(){
stop_moving();
     Speed(170);

     PORTB = PORTB |0b00000001;
      PORTB = PORTB |0b00000100;

}

void move_backwards(){
stop_moving();
     Speed(90);
     PORTB = PORTB | 0b00000010;
     PORTB = PORTB | 0b00001000;
}



void adjust_position(){
while((PORTD & 0b00000100)){
     sensor_voltage = ATD_read_A0();
     while(sensor_voltage < 70){
     move_backwards();
     sensor_voltage = ATD_read_A0();
}

if( sensor_voltage>=70) {break;}
if(!(PORTD & 0b00000100)){break;}
}
delayy(100);
stop_moving();
}




void check_and_extinguish_fire(){

//pump on while there is fire:
 sensor_voltage = ATD_read_A0();
 while ((PORTD & 0b00000100))
 {     //check if fire is too close or fire is too far (we check if its too far because
 //we read the digital signal from the front flame sensor so as not to pump water from too far distance)
       if(sensor_voltage <70 || sensor_voltage > 400) break;
       stop_moving();
       a=1;

       PORTB=PORTB|0B10000000;
       angle = 1000;
       PORTD=PORTD | 0B11000000;
       delayy(2000);


       angle = 3500;
       PORTD=PORTD & 0B00111111;
       delayy(2000);

       angle = 1000;
       PORTD=PORTD | 0B11000000;
       delayy(2000);
       angle = 3500;
       PORTD=PORTD & 0B00111111;
       delayy(2000);
       angle = 1000;
       PORTD=PORTD | 0B11000000;
 }
 PORTD=PORTD & 0B00111111;

angle =  2250;
delayy(2000);
a=0;
PORTB=PORTB & 0B01111111;
}


int dist(){
int d = 0;
T1CON = 0x10; // Use internal clock, no prescaler
delayy(100);


    TMR1H = 0;                  // Reset Timer1
    TMR1L = 0;

    PORTC = PORTC | 0b01000000; // Trigger HIGH
    delayy(1);               // 1 ms delay
    PORTC = PORTC & 0b10111111; // Trigger LOW

    while (!(PORTC & 0b10000000));


    T1CON = T1CON | 0b00000001; // Start Timer


    while (PORTC & 0b10000000);


    T1CON = T1CON & 0b11111110; // Stop Timer

    d = (TMR1L | (TMR1H << 8)); // Read Timer1 value
    d = d / 58.82;           // Convert time to distance (cm)


     delayy(10);
    T1CON = 0x01;
    return d;

}
