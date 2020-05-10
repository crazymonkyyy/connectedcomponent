struct array2d(T,size_t x,size_t y){
  T[x][y] payload; alias payload this;
  auto opIndex(size_t i,size_t j){
    return &payload[i][j];
  }
  void opIndexAssign(S)(S a,size_t i,size_t j){
    payload[i][j]=a;}
  auto opIndex(T* where){
    struct vec2{size_t x;size_t y;}
    T* zero=&payload[0][0];
    size_t n=(cast(size_t)(where-zero));// /T.sizeof;
    return vec2(n/x,n%x);
  }
}

unittest{
  array2d!(int,5,5) foo;
  int* bar=foo[2,3];
  import std.stdio;
  foreach(i;0..5){
  foreach(j;0..5){
    writeln(foo[foo[i,j]],i,",",j);}}
  assert(foo[bar].x==2);
  assert(foo[bar].y==3);
  *bar=5;
  assert(*bar==5);
}
unittest{
  struct vomit{float f;int i;bool b;}
  array2d!(vomit,5,5) foo;
  vomit* bar=foo[2,3];
  import std.stdio;
  foreach(i;0..5){
  foreach(j;0..5){
    writeln(foo[foo[i,j]],i,",",j);}}
  assert(foo[bar].x==2);
  assert(foo[bar].y==3);
}
unittest{
  import std.stdio;
  int foo;
  int* foo_=&foo;
  array2d!(int,5,5) bar;
  bar[foo_].writeln;
}