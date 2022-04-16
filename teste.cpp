#include <iostream>

#define True 1;
#define False 0;

using namespace std;

int main(){

        char t1[5]; //"brin"
        char* t2; //a

        t1[0] = 'b';
        t1[1] = 'r';
        t1[2] = 'i';
        t1[3] = 'n';
        t2 = t1;

        cout << t2 << endl;
}