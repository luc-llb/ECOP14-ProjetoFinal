# 1 "newmain.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:/Program Files (x86)/Microchip/MPLABX/v5.40/packs/Microchip/PIC18Fxxxx_DFP/1.2.26/xc8\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "newmain.c" 2








# 1 "./ssd.h" 1
# 22 "./ssd.h"
 void ssdDigit(char val, char pos);
 void ssdUpdate(void);
 void ssdInit(void);
# 9 "newmain.c" 2

# 1 "./lcd.h" 1


  void lcdCommand(char value);
  void lcdChar(char value);
  void lcdString(char msg[]);
  void lcdNumber(int value);
  void lcdPosition(int line, int col);
  void lcdInit(void);
# 10 "newmain.c" 2

# 1 "./keypad.h" 1


 unsigned int kpRead(void);
    char kpReadKey(void);
 void kpDebounce(void);
 void kpInit(void);
    void zeraKey(void);
# 11 "newmain.c" 2

# 1 "./pwm.h" 1
# 23 "./pwm.h"
 void pwmSet(unsigned char porcento);
 void pwmFrequency(unsigned int freq);
 void pwmInit(void);
# 12 "newmain.c" 2

# 1 "./bits.h" 1
# 13 "newmain.c" 2

# 1 "./timer.h" 1
# 23 "./timer.h"
 char timerEnded(void);
 void timerWait(void);

 void timerReset(unsigned int tempo);
 void timerInit(void);
# 14 "newmain.c" 2


const char User[] = "ULDR";
const char Passw[] = "ULDR";
char savU[5] = {0};
char savP[5] = {0};

char pegaUser() {
    static volatile char i = 0;
    zeraKey();
    kpDebounce();
    if (kpReadKey() != 0) {
        savU[i] = kpReadKey();
        lcdChar(savU[i]);
        i++;
        if (i == 4) {
            i = 0;
            return 2;
        }

    }
    return 1;
}

char pegaSenha() {
    static volatile char j = 0;
    zeraKey();
    kpDebounce();
    if (kpReadKey() != 0) {
        savP[j] = kpReadKey();
        lcdChar(savP[j]);
        j++;
        if (j == 4) {
            j = 0;
            return 3;
        }

    }
    return 2;
}

char comp() {
    char c = 0;
    for (char a = 0; a < 4; a++) {
        if ((savU[a] == User[a]) && (savP[a] == Passw[a])) {
            c++;
        }
    }

    if (c == 4) {
        return 1;
    } else {
        return 0;
    }
}

void limpaSSD() {
    ssdDigit(0, 0);
    ssdDigit(0, 1);
    ssdDigit(0, 2);
    ssdDigit(0, 3);
    for (volatile char k = 0; k < 5; k++) {
        ssdUpdate();
    }
}

void main(void) {
    timerInit();
    lcdInit();
    kpInit();
    pwmInit();
    ssdInit();

    char conf = 0;
    int cnt;
    volatile float k;
    limpaSSD();
    for (;;) {
        ssdUpdate();

        switch (conf) {
            case 0:
                lcdCommand(0x01);
                lcdPosition(0, 0);
                lcdString("User: ");
                lcdPosition(1, 0);
                lcdString("Senha: ");
                lcdPosition(0, 6);
                conf = 1;
                break;

            case 1:
                conf = pegaUser();
                ssdUpdate();
                if (conf == 2) {
                    lcdPosition(1, 7);
                }
                break;

            case 2:
                conf = pegaSenha();
                ssdUpdate();
                if (conf == 3) {
                    lcdCommand(0x01);
                }
                break;

            case 3:
                if (comp()) {
                    conf = 4;
                } else {
                    conf = 5;
                    ssdUpdate();
                    lcdPosition(0, 0);
                    lcdString("Entrada");
                    lcdPosition(1, 0);
                    lcdString("invalida!!");
                }
                break;

            case 4:
                lcdPosition(0, 2);
                lcdString("Bem-Vindo(a)");
                pwmFrequency(5000);
                pwmSet(50);
                for (cnt = 3601; cnt > 0; cnt--) {
                    if (cnt == 3600 || cnt == 100) {
                        pwmSet(100);
                    } else if (cnt == 3500 || cnt == 1) {
                        pwmSet(0);
                    }
                    ssdDigit((cnt / 60) % 10, 3);
                    ssdDigit((cnt / 600) % 6, 2);
                    ssdUpdate();
                    for (k = 0; k < 55; k++);
                }

                pwmSet(0);
                conf = 0;
                break;

            case 5:

                for (cnt = 550; cnt > 0; cnt--) {
                    if (cnt == 550 || cnt == 100) {
                        pwmSet(100);
                    } else if (cnt == 450 || cnt == 1) {
                        pwmSet(0);
                    }
                    ssdDigit((cnt / 100) % 10, 3);
                    ssdUpdate();
                    for (k = 0; k < 25; k++);
                }
                pwmSet(0);
                lcdCommand(0x01);
                conf = 0;

                break;
        }
        limpaSSD();
        for (k = 0; k < 12; k++) {
            ssdUpdate();
            for (volatile float u = 0; u < 10; u++);
        }
    }
}
