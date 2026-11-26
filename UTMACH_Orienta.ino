#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <string.h>
LiquidCrystal_I2C lcd(0x27,16,2);
const byte leds[]={5,6,7,8,9,10,11}; // rojo, amarillo, verde
const byte buzz[]={A0,A1};
const byte joySW=12, joyX=A2, joyY=A3;
char cmd[40], dest[24]="", lcd1[17]="", lcd2[17]="";
byte len=0, stage=0, lastJoy=0; bool overflowed=false, raw=HIGH, stable=HIGH;
unsigned long changed=0, joyAt=0, started=0, reportAt=0;
const char *state="IDLE";
void row(byte n,const char *s,char *out){ lcd.setCursor(0,n); byte i=0; while(i<16 && s[i]){out[i]=s[i];lcd.write(s[i]);i++;}while(i<16){out[i]=' ';lcd.write(' ');i++;}out[16]=0; }
void screen(const char *a,const char *b){row(0,a,lcd1);row(1,b,lcd2);}
bool buzOn[2]={false,false};
void buzzOn(byte i){buzOn[i]=true;tone(buzz[i],i?1000:650);}
void off(){for(byte i=0;i<7;i++)digitalWrite(leds[i],LOW);for(byte i=0;i<2;i++){noTone(buzz[i]);digitalWrite(buzz[i],LOW);buzOn[i]=false;}}
void report(){Serial.print(F("STATE:"));Serial.print(state);Serial.print('|');Serial.print(dest);Serial.print('|');for(byte i=0;i<7;i++)Serial.print(digitalRead(leds[i]));Serial.print('|');for(byte i=0;i<2;i++)Serial.print(buzOn[i]?1:0);Serial.print('|');Serial.print(lcd1);Serial.print('|');Serial.println(lcd2);reportAt=millis();}
void idle(){off();state="IDLE";dest[0]=0;screen("UTMACH ORIENTA","Elige destino");report();}
void errorRoute(){off();state="ERROR";for(byte i=0;i<2;i++)digitalWrite(leds[i],HIGH);screen("RUTA NO DISP.","Elige destino");report();}
void complete(){off();state="DONE";for(byte i=5;i<7;i++)digitalWrite(leds[i],HIGH);screen("RUTA COMPLETA",dest);report();}
void handle(){if(!strcmp(cmd,"PING")){Serial.println(F("PONG"));report();return;}if(!strcmp(cmd,"RESET")){idle();return;}if(!strcmp(cmd,"NO_ROUTE")){errorRoute();return;}if(!strncmp(cmd,"DEST:",5)){
 const char *id=cmd+5,*name=nullptr;
 if(!strcmp(id,"medicina"))name="Medicina";else if(!strcmp(id,"empresariales"))name="C. Empresariales";else if(!strcmp(id,"sociales"))name="C. Sociales";else if(!strcmp(id,"civil"))name="Ing. Civil";else if(!strcmp(id,"laboratorio"))name="Laboratorio 1";else if(!strcmp(id,"plaza"))name="Plazoleta";
 if(!name){dest[0]=0;errorRoute();return;}strcpy(dest,name);off();state="ROUTE";stage=0;started=millis();screen("DESTINO:",dest);for(byte i=2;i<5;i++)digitalWrite(leds[i],HIGH);buzzOn(0);report();
 }else if(!strcmp(cmd,"NAV:ARRIVED") && !strcmp(state,"ROUTE")){complete();} }
void setup(){for(byte i=0;i<7;i++)pinMode(leds[i],OUTPUT);for(byte i=0;i<2;i++)pinMode(buzz[i],OUTPUT);pinMode(joySW,INPUT_PULLUP);Serial.begin(9600);Wire.begin();lcd.init();Wire.setClock(50000UL);lcd.backlight();Serial.println(F("READY:UTMACH"));idle();}
void loop(){unsigned long now=millis();while(Serial.available()){char c=Serial.read();if(c=='\n'||c=='\r'){if(len&&!overflowed){cmd[len]=0;handle();}len=0;overflowed=false;}else if(len<sizeof(cmd)-1&&!overflowed)cmd[len++]=c;else overflowed=true;}
 now=millis();
 if(!strcmp(state,"ROUTE")){unsigned long elapsed=now-started;byte s=(elapsed/500UL)%2;if(elapsed>=60000UL){errorRoute();}else if(s!=stage){stage=s;off();if(s==0){for(byte i=2;i<5;i++)digitalWrite(leds[i],HIGH);buzzOn((elapsed/1000UL)%2);}report();}}
 int x=analogRead(joyX),y=analogRead(joyY);byte d=y<350?1:y>670?2:x<350?3:x>670?4:0;if(d && (d!=lastJoy||now-joyAt>=320)){if(d==1)Serial.println(F("JOY:UP"));if(d==2)Serial.println(F("JOY:DOWN"));if(d==3)Serial.println(F("JOY:LEFT"));if(d==4)Serial.println(F("JOY:RIGHT"));joyAt=now;}lastJoy=d;
 bool r=digitalRead(joySW);if(r!=raw){raw=r;changed=now;}if(now-changed>=45&&raw!=stable){stable=raw;if(!stable)Serial.println(F("JOY:OK"));}if(now-reportAt>=1000)report();}
