#line 1 "C:/Users/User/Desktop/New folder (2)/MyProject.c"



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
 time=0;
 while (time < time_ms);
}


void CCPPWM_init(){
 T2CON = 0x07;
 CCP2CON = 0x0C;
 PR2 = 250;
 CCPR2L = 125;
}


void Speed(int p){
 CCPR2L = p;
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




OPTION_REG = 0x87;
TMR0 = 0;



TMR1H = 0;
TMR1L = 0;
H_L = 1;
CCP1CON = 0x08;

T1CON = 0x01;

INTCON = 0b11100000;
PIE1 = PIE1|0x04;
CCPR1H = 2000>>8;
CCPR1L = 2000;





}





void interrupt(){
 if(INTCON & 0x04){

 time++;
 tick1++;

 INTCON = INTCON & 0xFB;
 }
if(PIR1 & 0x04){
 if(a==1){
 if(H_L){
 CCPR1H = angle >> 8;
 CCPR1L = angle;
 H_L = 0;
 CCP1CON = 0x09;
 TMR1H = 0;
 TMR1L = 0;
 }
 else{
 CCPR1H = (40000 - angle) >> 8;
 CCPR1L = (40000 - angle);
 CCP1CON = 0x08;
 H_L = 1;
 TMR1H = 0;
 TMR1L = 0;
 } }else{
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
ADCON0=0x41;
 ADCON1=0xCE;
 TRISA=0x01;

}

int ATD_read_A0(){
ADCON0=ADCON0 | 0x04;
 while(ADCON0&0x04);
 return (ADRESH<<8)|ADRESL;

}




 void check_front_right(){

if(PORTD & 0b00000001){
 tick1 = 0;

 while(!(PORTD & 0b00000100)){


 if (tick1 >= turning_time_delay) break;

 move_right();

 }
 delay_ms(100);

stop_moving();
}
 }


void check_front_left(){

if ((PORTD & 0b00000010)){
 tick1 = 0;

 while(!(PORTD & 0b00000100)){

 if (tick1 >= turning_time_delay) break;
 move_left();
 }

stop_moving();
}
}

void check_front(){
while((PORTD & 0b00000100)){
sensor_voltage = ATD_read_A0();


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


 sensor_voltage = ATD_read_A0();
 while ((PORTD & 0b00000100))
 {

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

angle = 2250;
delayy(2000);
a=0;
PORTB=PORTB & 0B01111111;
}


int dist(){
int d = 0;
T1CON = 0x10;
delayy(100);


 TMR1H = 0;
 TMR1L = 0;

 PORTC = PORTC | 0b01000000;
 delayy(1);
 PORTC = PORTC & 0b10111111;

 while (!(PORTC & 0b10000000));


 T1CON = T1CON | 0b00000001;


 while (PORTC & 0b10000000);


 T1CON = T1CON & 0b11111110;

 d = (TMR1L | (TMR1H << 8));
 d = d / 58.82;


 delayy(10);
 T1CON = 0x01;
 return d;

}
