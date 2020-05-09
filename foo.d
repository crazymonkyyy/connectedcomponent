struct foo(T){
  T payload; alias payload this;
  int i;
  void opAssign(S)(S a){
    payload=a;
    i++;
  }
}
struct bar(T){
  T payload; alias payload this;
  bool b;
  void opAssign(S)(S a){
    payload=a;
    b= !b;
  }
}
struct fizz(T){
  T payload; alias payload this;
  float f;
  void opAssign(S)(S a){
    payload=a;
    f= f*2;
  }
}
alias buzz=foo!(bar!(fizz!ubyte));
alias panic=foo!(bar!(fizz!(ubyte*)));

unittest{
  buzz hello;
  hello = ubyte(3);
}
unittest{
  buzz hello;
  buzz* bye= &hello;
  *bye = ubyte(3);
  ubyte ahoy= *bye;
}
unittest{
  ubyte bye=ubyte(2);
  panic hello;
  hello = &bye;
}