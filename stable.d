unittest{
  mixin(import("stable.mix"));
  struct foo{
    void opOpAssign(string op,T)(T a){}
  }
  foo unstables;
  stable!(int) bar;
  stable!(int)* fizz;
  fizz=&bar;
  *fizz=1;
  assert(bar==1);
}