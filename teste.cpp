#include <iostream>

#define True 1;
#define False 0;

using namespace std;

int main()
{
        int t1; //0
        int t2; //i

        int t3; //10
        int t4;
        int t5; //1
        int t6;
        int t7;
        int t8; //1
        int t9;
        t1 = 0;
        t2 = t1;

        label1:
        t3 = 10;
        t4 = t2 < t3;
        t5 = 1;
        t7 = !t4;
        if(t7) goto label2;
        t8 = 1;
        t9 = t2 + t8;
        cout << t9 << endl;
        label3:
        t6 = t2 + t5;
        t2 = t6;
        goto label1;
        label2:

        return 0;
}